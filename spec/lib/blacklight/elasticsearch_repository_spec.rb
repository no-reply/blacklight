require 'spec_helper'

describe Blacklight::ElasticsearchRepository do

  it_behaves_like 'a repository'

  subject { described_class.new(blacklight_config) }
  let(:blacklight_config) { Blacklight::Configuration.new }

  it 'has an es connection' do
    expect(subject.send(:blacklight_es))
      .to be_a Elasticsearch::Transport::Client
  end

  describe '#search' do
  end
end
