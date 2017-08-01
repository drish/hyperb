require "helper"

RSpec.describe Hyperb::Request do

  before do
    @client = Hyperb::Client.new(access_key: 'ak', secret_key: 'sk')
  end

  it "#singed_headers without signature" do
    req = Hyperb::Request.new(@client, '/', 'get')
    expect(req.signed_headers).to eql('content-type;host;x-hyper-content-sha256;x-hyper-date')
  end

  it "#singed_headers with signature" do
    req = Hyperb::Request.new(@client, '/', 'get')
    req.sign
    expect(req.signed_headers).to eql('authorization;content-type;host;x-hyper-content-sha256;x-hyper-date')
  end

  it "#sign" do
    req = Hyperb::Request.new(@client, '/', 'get')
    req.sign
    expect(req.headers[:authorization]).not_to be nil
    expect(req.signed).to be true
  end

  it "should merge optional headers" do
    optional_headers = { x_header: 't' }
    req = Hyperb::Request.new(@client, '/', 'get', '', optional_headers)
    expect(req.headers[:x_header]).not_to be nil
    expect(req.headers[:x_header]).to eql('t')
  end

  it "should add optional header to SignedHeaders header" do
    optional_headers = { x_header: 't' }
    req = Hyperb::Request.new(@client, '/', 'get', '', optional_headers)
    req.sign
    expect(req.signed_headers).to eql('authorization;content-type;host;x-header;x-hyper-content-sha256;x-hyper-date')
  end

end
