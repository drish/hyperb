require 'helper'

RSpec.describe Hyperb::Network do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @base_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/fips'
  end

  describe '#fip_allocate' do

    it 'should raise ArgumentError when count is not provided' do
      expect { @client.fip_allocate }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + '/allocate?count=1'
      stub_request(:post, path)
      .to_return(body: fixture('fip_allocate.json'))

      @client.fip_allocate count: 1
      expect(a_request(:post, path)).to have_been_made
    end
  end

  describe '#fip_attach' do

    it 'should raise ArgumentError when container is not provided' do
      expect { @client.fip_attach }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when ip is not provided' do
      expect { @client.fip_attach }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when container and ip are not provided' do
      expect { @client.fip_attach }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + '/attach?container=nginx&ip=8.8.8.8'
      stub_request(:post, path)
      .to_return(body: "")

      @client.fip_attach ip: '8.8.8.8', container: 'nginx'
      expect(a_request(:post, path)).to have_been_made
    end
  end

  describe '#fip_detach' do

    it 'should raise ArgumentError when container is not provided' do
      expect { @client.fip_detach }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + '/detach?container=nginx'
      stub_request(:post, path)
      .to_return(body: "")

      @client.fip_detach container: 'nginx'
      expect(a_request(:post, path)).to have_been_made
    end
  end

  describe '#fips_ls' do

    it 'request to the correct path should be made' do
      path = @base_path
      stub_request(:get, path)
      .to_return(body: fixture('fips_ls.json'))

      @client.fips_ls
      expect(a_request(:get, path)).to have_been_made
    end

    it 'should return correct attrs' do
      path = @base_path
      stub_request(:get, path)
      .to_return(body: fixture('fips_ls.json'))

      fips = @client.fips_ls
      expect(fips).to be_a Array
      expect(fips.first.key?(:container)).to be true
      expect(fips.first.key?(:service)).to be true
      expect(fips.first.key?(:fip)).to be true
      expect(fips.first.key?(:name)).to be true
    end
  end

  describe '#fip_name' do

    it 'should raise ArgumentError when ip is not provided' do
      expect { @client.fip_name(name: 'test') }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when name is not provided' do
      expect { @client.fip_name(ip: '8.8.8.8') }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + '/name?ip=8.8.8.8&name=haproxy'
      stub_request(:post, path)
      .to_return(body: "")

      @client.fip_name(ip: '8.8.8.8', name: 'haproxy')
      expect(a_request(:post, path)).to have_been_made
    end
  end

  describe '#fip_release' do

    it 'should raise ArgumentError when ip is not provided' do
      expect { @client.fip_allocate }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + '/release?ip=8.8.8.8'
      stub_request(:post, path)
      .to_return(body: "")

      @client.fip_release ip: '8.8.8.8'
      expect(a_request(:post, path)).to have_been_made
    end
  end
end
