require 'spec_helper'

describe 'ZapierRuby' do
  let(:zapper) { ZapierRuby::Zapper }
  let(:catch_url) { 'https://zapier.com/hooks/catch/webhook_id/' }
  let(:standard_url) do
    'https://zapier.com/hooks/standard/standard_webhook_id/uuiq/'
  end

  describe '#zap_url' do
    it 'catch url' do
      expect(zapper.new(:example_zap).send(:zap_url)).to eq catch_url
    end

    context 'standard url' do
      let(:opt_hash) { { hook_path: 'standard' } }

      it 'web_hook_id is nil' do
        expect(zapper.new(:standard_example_zap, nil, opt_hash).send(:zap_url)).to eq standard_url
      end

      it 'web_hook_id has val' do
        url = zapper.new(:nil, 'standard_webhook_id/uuiq', opt_hash).send(:zap_url)
        expect(url).to eq standard_url
      end
    end
  end

  it '.base_uri' do
    expect(ZapierRuby.config.base_uri).to eq "https://zapier.com/hooks/"
  end
end
