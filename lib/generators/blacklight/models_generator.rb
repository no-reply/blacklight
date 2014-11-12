require 'rails/generators'
require 'rails/generators/migration'

module Blacklight
  class ModelsGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    desc """
This generator makes the following changes to your application:
 1. Creates several database migrations if they do not exist in /db/migrate
 2. Creates config/solr.yml with a default solr configuration
 4. Creates a blacklight document in your /app/models directory
"""

    # Copy all files in templates/config directory to host config
    def create_configuration_files
      copy_file "config/solr.yml", "config/solr.yml"
    end


    # Setup the database migrations
    def copy_migrations
      rake "blacklight:install:migrations"
    end

    def create_solr_document
      copy_file "solr_document.rb", "app/models/solr_document.rb"
    end

  end
end
