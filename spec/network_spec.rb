require 'helper'

RSpec.describe Hyperb::Request do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @base_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/fips/'
  end

  describe '#fip_allocate' do

    it 'should raise ArgumentError when count is not provided' do
      expect { @client.fip_allocate }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + 'allocate?count=1'
      stub_request(:post, path)
      .to_return(body: fixture('fip_allocate.json'))

      @client.fip_allocate count: 1
      expect(a_request(:post, path)).to have_been_made
    end
  end
end
