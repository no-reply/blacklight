module Blacklight
  class ControllersGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    # Add Blacklight to the application controller
    def inject_blacklight_controller_behavior    
      inject_into_class "app/controllers/application_controller.rb", "ApplicationController" do
        "  # Adds a few additional behaviors into the application controller \n " +        
          "  include Blacklight::Controller\n" + 
          "  # Please be sure to impelement current_user and user_session. Blacklight depends on \n" +
          "  # these methods in order to perform user specific actions. \n\n" +
          "  layout 'blacklight'\n\n"
      end
    end
    
    # Generate blacklight catalog controller
    def create_blacklight_catalog
      copy_file "catalog_controller.rb", "app/controllers/catalog_controller.rb"
    end 

    def inject_blacklight_routes
      # These will end up in routes.rb file in reverse order
      # we add em, since each is added at the top of file. 
      # we want "root" to be FIRST for optimal url generation. 
      route('blacklight_for :catalog')
      route('root :to => "catalog#index"')
    end
  end
end
