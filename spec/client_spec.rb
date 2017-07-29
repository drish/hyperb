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
end
