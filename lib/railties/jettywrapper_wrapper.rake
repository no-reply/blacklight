require 'jettywrapper'

URLS = {
  solr: "https://github.com/projectblacklight/blacklight-jetty/archive/v4.10.2.zip",
  es: "https://github.com/mistydemeo/blacklight-jetty/archive/v1.4.1-1.zip"
}

# Allow specifying which search engine to install, Solr or ES
Rake::Task["jetty:download"].clear
Rake::Task["jetty:unzip"].clear
Rake::Task["jetty:clean"].clear
namespace :jetty do
  desc "download the jetty zip file"
  task :download, [:container] do |_, args|
    args.with_defaults(container: "solr")

    Jettywrapper.url = URLS[args.container.to_sym]
    Jettywrapper.download(url)
  end

  desc "remove the jetty directory and recreate it"
  task :clean, [:container] do |_, args|
    args.with_defaults(container: "solr")

    Jettywrapper.url = URLS[args.container.to_sym]
    Jettywrapper.clean
  end

  desc "unzip the downloaded jetty archive"
  task :unzip [:container] do |_, args|
    args.with_defaults(container: "solr")

    Jettywrapper.url = URLS[args.container.to_sym]
    Jettywrapper.unzip
  end
end
