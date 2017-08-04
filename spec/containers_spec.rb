require 'helper'
require 'http'

RSpec.describe Hyperb::Containers do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @containers_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/containers/json'
  end

  describe '#containers' do

    before do
      stub_request(:get, @containers_path)
      .to_return(body: fixture('containers.json'))
    end

    it 'request to the correct path should be made' do
      @client.containers
      expect(a_request(:get, @containers_path)).to have_been_made
    end

  end

end
