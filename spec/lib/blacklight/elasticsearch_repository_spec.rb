require 'spec_helper'

describe Blacklight::ElasticsearchRepository do
  subject { described_class.new(blacklight_config) }
  let(:blacklight_config) { Blacklight::Configuration.new }

  it 'has an es connection' do
    expect(subject.send(:blacklight_es))
      .to be_a Elasticsearch::Transport::Client
  end

  describe '#find' do
    it 'raises an error on invalid id' do
      expect { subject.find('fake_id') }
        .to raise_error Blacklight::Exceptions::InvalidSolrID
    end
  end

  describe '#search' do
  end
end
