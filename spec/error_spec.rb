require "helper"

RSpec.describe Hyperb::Error do

  before do
    @path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/version'
    @client = Hyperb::Client.new secret_key: '123', access_key: 'ak'
    @req = Hyperb::Request.new(@client, '/version', 'get', '20170729T230845Z')
    @req.sign
  end

  Hyperb::Error::ERRORS.each do |code, exception|
    it "#{exception}" do
      stub_request(:get, @path)
      .with(headers: { 'Authorization' => @req.headers[:authorization] })
      .to_return(status: code)

      expect { @req.perform }.to raise_error(exception)
    end
  end

end
