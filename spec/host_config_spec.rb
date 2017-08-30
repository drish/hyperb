require 'helper'

RSpec.describe Hyperb::HostConfig do

  it '#fmt' do
    host_config = Hyperb::HostConfig.new(binds: ['path/to/binds'], publish_all_ports: false)
    formated = host_config.fmt
    expect(formated).to be_a Hash
    expect(formated.key?('Binds')).to be true
    expect(formated.key?('PublishAllPorts')).to be true
  end

  it '#attrs' do
    host_config = Hyperb::HostConfig.new(binds: 'path/to/binds')
    expect(host_config.attrs).to be_a Hash
    expect(host_config.attrs[:binds]).to be_a String
  end
end
