shared_examples_for 'a repository' do
  let(:repository) { subject || described_class.new(blacklight_config) }
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }

  describe '#find' do
    it 'raises an error on invalid id' do
      expect { repository.find('fake_id') }
        .to raise_error Blacklight::Exceptions::InvalidSolrID
    end
  end
end
