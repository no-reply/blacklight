# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Blacklight::SolrHelper do
  before do
    class SolrHelperTest
      include Blacklight::SolrHelper

      def blacklight_config
        @blacklight_config ||= Blacklight::Configuration.new
      end

      def params
        {}
      end
    end
  end

  after do
    Object.send(:remove_const, 'SolrHelperTest')
  end

  subject { SolrHelperTest.new }

  it 'has a solr repository' do
    expect(subject.solr_repository).to be_a subject.blacklight_config.repository_type
  end

  describe '#query_solr' do
    it 'sends query to repository with default params' do
      expect(subject.solr_repository).to receive(:search).with(subject.solr_search_params)
      subject.query_solr
    end

    context 'with user params' do
      let(:user_params) { {:sort => 'title'} }
      let(:extra_params) { {:extra => 'parameter'} }

      before do
        allow(subject).to receive(:solr_search_params).with(user_params).and_return(user_params)
      end

      it 'adds to default params' do
        expect(subject.solr_repository).to receive(:search).with(user_params)
        subject.query_solr(user_params)
      end

      it 'merges additional params' do
        expect(subject.solr_repository).to receive(:search).with(user_params.merge(extra_params))
        subject.query_solr(user_params, extra_params)
      end
    end
  end
end
