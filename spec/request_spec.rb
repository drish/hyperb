require "helper"

RSpec.describe Hyperb::Request do

  it "date should be in right format" do
    client = Hyperb::Client.new secret_key: 'SK'
    client.date
  end
end
