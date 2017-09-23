require "helper"

RSpec.describe Hyperb::Client do

  it 'simple init' do
    client = Hyperb::Client.new do |c|
      c.access_key = 'k'
      c.secret_key = 's'
    end
    expect(client.access_key).to eq 'k'
    expect(client.secret_key).to eq 's'
  end

  describe '#credentials?' do

    it 'returns true if all credentials are set' do
      client = Hyperb::Client.new(secret_key: 'SK', access_key: 'AK')
      expect(client.credentials?).to be true
    end

    it 'returns false if some credential is not set' do
      client = Hyperb::Client.new(secret_key: 'SK')
      expect(client.credentials?).to be false
    end
  end

  describe '#region' do

    it 'should set region' do
      client = Hyperb::Client.new do |c|
        c.access_key = 's'
        c.secret_key = 'key'
        c.region = 'eu-central-1'
      end
      expect(client.region).to eql('eu-central-1')
    end

    it 'should raise UnsupportedRegion' do
      expect { Hyperb::Client.new(access_key: 's', secret_key: 'key', region: 'eu-unsup')}.to raise_error(Hyperb::Error::UnsupportedRegion, 'Unsupported region: eu-unsup')
    end

    it 'new should set default region' do
      client = Hyperb::Client.new do |c|
        c.access_key = 's'
        c.secret_key = 'key'
      end
      expect(client.region).to eql(client.default_region)
    end
  end
end
