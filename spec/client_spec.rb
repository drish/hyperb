require "helper"

RSpec.describe Hyperb::Client do

  describe '#credentials?' do
    
    it 'returns true if all credentials are set' do
      client = Hyperb::Client.new(secret_key: 'SK', access_key: 'AK')
      expect(client.credentials?).to be true      
    end
  end
end
