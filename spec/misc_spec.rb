require 'helper'

RSpec.describe Hyperb::Misc do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @base_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/info'
  end

  describe '#info' do

    it 'request to the correct path should be made' do
      path = @base_path
      stub_request(:get, path)
      .to_return(body: fixture('info.json'))

      @client.info
      expect(a_request(:get, path)).to have_been_made
    end
  end
end
