require "helper"

RSpec.describe Hyperb::Request do

  it "#singed_headers" do
    req = Hyperb::Request.new(Hyperb::Client.new(access_key: 'ak', secret_key: 'sk'), '/', 'get')
    expect(req.signed_headers).to eql('content-type;host;x-hyper-content-sha256;x-hyper-date')
  end

  it "#sign" do
    d = '20170729T230845Z'
    req = Hyperb::Request.new(Hyperb::Client.new(access_key: 'ak', secret_key: 'sk'), '/', 'get', d)
    req.sign
    header = 'HYPER-HMAC-SHA256 Credential=ak/20170729/us-west-1/hyper/hyper_request, SignedHeaders=content-type;host;x-hyper-content-sha256;x-hyper-date, Signature=3a923718db713abc7b851712a434343eb7887298ab5f48113a7b291f261c037a'
    expect(req.headers[:authorization]).to eql(header)
    expect(req.signed).to be true
  end

end
