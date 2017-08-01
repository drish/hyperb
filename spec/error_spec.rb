require "helper"

RSpec.describe Hyperb::Error do

  before do
    # random url for request mocking
    @path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/version'
    @client = Hyperb::Client.new secret_key: '123', access_key: 'ak'
  end

  Hyperb::Error::ERRORS.each do |code, exception|
    it "#{exception}" do
      stub_request(:get, @path).to_return(status: code)
      expect { @client.version }.to raise_error(exception)
    end
  end

end
