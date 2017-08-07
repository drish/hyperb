require 'helper'
require 'http'

RSpec.describe Hyperb::Images do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @base_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/volumes'
  end

  describe '#remove_volume' do

    it 'should raise ArgumentError when id is not provided' do
      expect { @client.remove_volume }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + '/id'

      stub_request(:delete, path)
      .to_return(body: fixture('remove_container.json'))

      @client.remove_volume id: 'id'
      expect(a_request(:delete, path)).to have_been_made
    end
  end

  describe '#inspect_volume' do

    it 'should raise ArgumentError when id is not provided' do
      expect { @client.inspect_volume }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + '/id'

      stub_request(:get, path)
      .to_return(body: fixture('inspect_container.json'))

      @client.inspect_volume id: 'id'
      expect(a_request(:get, path)).to have_been_made
    end


    it 'correct attrs' do
      path = @base_path + '/id'

      stub_request(:get, path)
      .to_return(body: fixture('inspect_container.json'))

      vol = @client.inspect_volume id: 'id'
      expect(vol.key?(:name)).to be true
      expect(vol.key?(:driver)).to be true
    end
  end

end
