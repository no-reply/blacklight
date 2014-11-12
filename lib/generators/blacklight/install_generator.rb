module Blacklight
  class Install < Rails::Generators::Base
    
    source_root File.expand_path('../templates', __FILE__)
    
    argument     :model_name  , type: :string , default: "user"
    class_option :devise      , type: :boolean, default: false, aliases: "-d", desc: "Use Devise as authentication logic."
    class_option :jettywrapper, type: :boolean, default: false, desc: "Use jettywrapper to download and control Jetty"
    class_option :marc        , type: :boolean, default: false, aliases: "-m", desc: "Generate MARC-based demo ."

    desc """
  This generator makes the following changes to your application:
   1. Generates blacklight:models
   2. Creates a number of public assets, including images, stylesheets, and javascript
   3. Injects behavior into your user application_controller.rb
   4. Adds example configurations for dealing with MARC-like data
   5. Adds Blacklight routes to your ./config/routes.rb


  Thank you for Installing Blacklight.
         """

    def install_jettywrapper
      generate "blacklight:jettywrapper" if options[:jettywrapper]
    end

    # Copy all files in templates/public/ directory to public/
    # Call external generator in AssetsGenerator, so we can
    # leave that callable seperately too. 
    def copy_public_assets 
      generate "blacklight:assets"
    end

    def generate_devise_users
      if options[:devise]
        generate 'blacklight:users', model_name
      end
    end

    def generate_blacklight_models
      generate 'blacklight:models'
    end

    # Generate blacklight catalog controller
    def create_blacklight_catalog
      generate "blacklight:controllers"
    end 

    def generate_blacklight_marc_demo
      if options[:marc]
        gem "blacklight-marc", "~> 5.0"

        Bundler.with_clean_env do
          run "bundle install"
        end

        generate 'blacklight_marc:marc'
      end
    end

    def add_sass_configuration

      insert_into_file "config/application.rb", :after => "config.assets.enabled = true" do <<EOF
      
      # Default SASS Configuration, check out https://github.com/rails/sass-rails for details
      config.assets.compress = !Rails.env.development?
EOF
      end
    end

    def inject_blacklight_i18n_strings
      copy_file "blacklight.en.yml", "config/locales/blacklight.en.yml"
    end

    def add_blacklight_initializer
      template "config/initializers/blacklight_initializer.rb"
    end
  end
end
