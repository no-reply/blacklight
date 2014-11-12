module Blacklight
  class JettywrapperGenerator < Rails::Generators::Base
    desc """
  This generator makes the following changes to your application:
   1. Generates jettywrapper


  Thank you for Installing Blacklight.
         """

    def install_jettywrapper
      return unless options[:jettywrapper]
      gem "jettywrapper", "~> 1.7"

      copy_file "config/jetty.yml"

      append_to_file "Rakefile",
        "\nZIP_URL = \"https://github.com/projectblacklight/blacklight-jetty/archive/v4.9.0.zip\"\n" +
        "require 'jettywrapper'\n"

      Bundler.with_clean_env do
        run "bundle install"
      end
    end
  end
end
