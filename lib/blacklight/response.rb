module Blacklight
  class Response < HashWithIndifferentAccess
    attr_reader :request_params
    attr_accessor :solr_document_model

    def initialize(data, request_params, options = {})
      super(force_to_utf8(data))
      @request_params = request_params
      self.solr_document_model = options[:solr_document_model] || SolrDocument
    end
    def documents
      docs.collect{|doc| solr_document_model.new(doc, self) }
    end

    private

      def force_to_utf8(value)
        case value
        when Hash
          value.each { |k, v| value[k] = force_to_utf8(v) }
        when Array
          value.each { |v| force_to_utf8(v) }
        when String
          value.force_encoding("utf-8")  if value.respond_to?(:force_encoding)
        end
        value
      end
  end
end
