module Blacklight
  # Implement the RequestBuilders interface with Elasticsearch parameters
  # @see: Blacklight::RequestBuilders
  module ElasticsearchRequestBuilders
    extend ActiveSupport::Concern

    included do
      # We want to install a class-level place to keep
      # search_params_logic method names. Compare to before_filter,
      # similar design. Since we're a module, we have to add it in here.
      # There are too many different semantic choices in ruby 'class variables',
      # we choose this one for now, supplied by Rails.
      class_attribute :search_params_logic

      # Set defaults. Each symbol identifies a _method_ that must be in
      # this class, taking two parameters (solr_parameters, user_parameters)
      # Can be changed in local apps or by plugins, eg:
      # CatalogController.include ModuleDefiningNewMethod
      # CatalogController.search_params_logic += [:new_method]
      # CatalogController.search_params_logic.delete(:we_dont_want)
      self.search_params_logic = []

      if self.respond_to?(:helper_method)
        helper_method(:facet_limit_for)
      end
    end

    def solr_search_params
      {:q => ''}
    end

    def solr_document_ids_params(ids = [])
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def solr_documents_by_field_values_params(field, values)
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def solr_facet_params(facet_field, user_params=params || {}, extra_controller_params={})
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def solr_opensearch_params(field=nil)
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def previous_and_next_document_params(index, window = 1)
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def default_solr_parameters(solr_parameters, user_params)
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def add_query_to_solr(solr_parameters, user_parameters)
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def add_facet_fq_to_solr(solr_parameters, user_params)
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def add_facetting_to_solr(solr_parameters, user_params)
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def add_solr_fields_to_query solr_parameters, user_parameters
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def add_paging_to_solr(solr_params, user_params)
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def add_sorting_to_solr(solr_parameters, user_params)
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def add_group_config_to_solr solr_parameters, user_parameters
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def facet_limit_for(facet_field)
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def solr_param_quote(val, options = {})
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end

    def should_add_to_solr field_name, field
      raise NotImplementedError, 'not yet implemented for Elasticsearch'
    end
  end
end
