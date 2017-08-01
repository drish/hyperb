require "helper"

RSpec.describe Hyperb::Request do

  it "#singed_headers" do
    req = Hyperb::Request.new(Hyperb::Client.new(access_key: 'ak', secret_key: 'sk'), '/', 'get')
    expect(req.signed_headers).to eql('content-type;host;x-hyper-content-sha256;x-hyper-date')
  end

  it "#sign" do
    req = Hyperb::Request.new(Hyperb::Client.new(access_key: 'ak', secret_key: 'sk'), '/', 'get')
    req.sign
    expect(req.headers[:authorization]).not_to be nil
    expect(req.signed).to be true
  end

end
