require "elasticsearch"

namespace :blacklight do
  # task to clean out old, unsaved searches
  # rake blacklight:delete_old_searches[days_old]
  # example cron entry to delete searches older than 7 days at 2:00 AM every day: 
  # 0 2 * * * cd /path/to/your/app && /path/to/rake blacklight:delete_old_searches[7] RAILS_ENV=your_env
  desc "Removes entries in the searches table that are older than the number of days given."
  task :delete_old_searches, [:days_old] => [:environment] do |t, args|
    args.with_defaults(:days_old => 7)    
    Search.delete_old_searches(args[:days_old].to_i)
  end

  namespace :es do
    desc "Put sample data into elasticsearch"
    task :seed do
      docs = YAML::load(File.open(File.join(Blacklight.root, 'solr', 'sample_solr_documents.yml')))

      # TODO: call Blacklight::ElasticsearchRepository
      client = Elasticsearch::Client.new hosts: ['0.0.0.0:8983']
      docs.each do |doc|
        client.index index: :marctest, type: :marcrecord, body: doc
      end
    end

    desc "Create marcrecord test record mapping"
    task :create_index do
      mapping = JSON::load(File.open(File.join(Blacklight.root, 'es', 'mappings', 'marcrecord.json')))
      client = Elasticsearch::Client.new hosts: ['0.0.0.0:8983']

      # Clear out testdata before indexing
      begin
        client.indices.delete index: :marctest
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
      end
      client.indices.create index: :marctest, body: {mappings: mapping}
    end
  end

  namespace :solr do
    desc "Put sample data into solr"
    task :seed do
      docs = YAML::load(File.open(File.join(Blacklight.root, 'solr', 'sample_solr_documents.yml')))
      Blacklight.solr.add docs
      Blacklight.solr.commit
    end
  end

  namespace :check do
    desc "Check the Solr connection and controller configuration"
    task :solr, [:controller_name] => [:environment] do |_, args|
      errors = 0
      verbose = ENV.fetch('VERBOSE', false).present?

      puts "[#{Blacklight.solr.uri}]"

      print " - admin/ping: "
      begin
        response = Blacklight.solr.send_and_receive 'admin/ping', {}
        puts response['status']
        errors += 1 unless response['status'] == "OK"
      rescue Exception => e
        errors += 1
        puts e.to_s
      end

      exit 1 if errors > 0
    end

    desc "Check the Elasticsearch connection"
    task :es do
      client = Elasticsearch::Client.new hosts: ['0.0.0.0:8983']
      begin
        failed = !client.ping
      rescue Faraday::ConnectionFailed
        failed = true
      end

      if failed
        puts "Unable to connect to Elasticsearch"
        exit 1
      end
    end

    task :controller, [:controller_name] => [:environment] do |_, args|
      errors = 0
      verbose = ENV.fetch('VERBOSE', false).present?
      controller = args[:controller_name].constantize.new if args[:controller_name]
      controller ||= CatalogController.new

      puts "[#{controller.class.to_s}]"

      print " - find: "

      begin
        response = controller.find q: '{!lucene}*:*'
        if response.header['status'] == 0
          puts "OK"
        else
          errors += 1
        end

        if verbose
          puts "\tstatus: #{response.header['status']}"
          puts "\tnumFound: #{response.response['numFound']}"
          puts "\tdoc count: #{response.docs.length}"
          puts "\tfacet fields: #{response.facets.length}"
        end
      rescue Exception => e
        errors += 1
        puts e.to_s
      end

      print " - get_search_results: "
  
      begin
        response, docs = controller.get_search_results({}, q: '{!lucene}*:*')

        if response.header['status'] == 0 and docs.length > 0
          puts "OK"
        else
          errors += 1
        end

        if verbose
          puts "\tstatus: #{response.header['status']}"
          puts "\tnumFound: #{response.response['numFound']}"
          puts "\tdoc count: #{docs.length}"
          puts "\tfacet fields: #{response.facets.length}"
        end
      rescue Exception => e
        errors += 1
        puts e.to_s
      end

      print " - get_solr_response_for_doc_id: "

      begin
        doc_id = response.docs.first[SolrDocument.unique_key]
        response, doc = controller.get_solr_response_for_doc_id doc_id

        if response.header['status'] == 0 and doc
          puts "OK"
        else
          errors += 1
        end

        if verbose
          puts "\tstatus: #{response.header['status']}"
        end
      rescue Exception => e
        errors += 1
        puts e.to_s
      end

      exit 1 if errors > 0
    end
  end
end
