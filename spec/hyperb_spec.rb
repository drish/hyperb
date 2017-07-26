require "spec_helper"

RSpec.describe Hyperb do
  
  it "has a version number" do
    expect(Hyperb::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end

  it 'lol' do
    expect(Hyperb::Client.lol('not lol')).to eql('lolzinnn')
  end
end
