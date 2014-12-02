require 'elasticsearch'

module Blacklight
  class ElasticsearchRepository < Repository

    def find(id, params = {})
      raise Blacklight::Exceptions::InvalidSolrID
    end

    def search(params = {})
      #blacklight_config.solr_response_model.new
    end

    protected

    def blacklight_es
      @blacklight_es ||= Elasticsearch::Client.new
    end
  end
end
