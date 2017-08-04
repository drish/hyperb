require 'helper'

RSpec.describe Hyperb::AuthObject do

  it '#valid? with invalid object' do
    auth_object = Hyperb::AuthObject.new(username: '')
    expect(auth_object.valid?).to be false
  end

  it '#valid? with valid object' do
    auth_object = Hyperb::AuthObject.new(username: 'l', email: 't@t.com', password: fixture('auth_obj.json'), serveraddress: 'https://gcr.io')
    expect(auth_object.valid?).to be true
  end

  it '#attrs' do
    auth_object = Hyperb::AuthObject.new(username: 'l', email: 't@t.com', password: fixture('auth_obj.json'), serveraddress: 'https://gcr.io')
    expect(auth_object.attrs).to be_a Hash
    expect(auth_object.attrs[:username]).to eql('l')
    expect(auth_object.attrs[:email]).to eql('t@t.com')
    expect(auth_object.attrs[:password]).to eql(fixture('auth_obj.json').read)
    expect(auth_object.attrs[:serveraddress]).to eql('https://gcr.io')
  end

  it '#password should read contents of file when File' do
    auth_object = Hyperb::AuthObject.new(username: 'l', email: 't@t.com', password: fixture('auth_obj.json'))
    expect(auth_object.attrs[:password]).to eql(fixture('auth_obj.json').read)
  end

  it '#password should also accept a String' do
    auth_object = Hyperb::AuthObject.new(username: 'l', email: 't@t.com', password: fixture('auth_obj.json').read)
    expect(auth_object.attrs[:password]).to eql(fixture('auth_obj.json').read)
  end

  it '#encode' do
    auth_object = Hyperb::AuthObject.new(username: 'l', email: 't@t.com', password: fixture('auth_obj.json'))
    expect(auth_object.encode).not_to be nil
  end

  it '#build' do
    auth_object = Hyperb::AuthObject.new(username: 'l', email: 't@t.com', password: fixture('auth_obj.json'))
    expect(auth_object.build).to be_a Hash
    expect(auth_object.build.has_key?(:x_registry_auth)).to be true
  end

end
