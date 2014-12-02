module Blacklight
  class Repository
    attr_accessor :blacklight_config

    # ActiveSupport::Benchmarkable requires a logger method
    attr_accessor :logger

    include ActiveSupport::Benchmarkable

    def initialize(blacklight_config)
      @blacklight_config = blacklight_config
    end

    protected

    def logger
      @logger ||= Rails.logger if defined? Rails
    end
  end
end
