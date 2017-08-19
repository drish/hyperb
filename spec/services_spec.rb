require 'helper'
require 'http'

RSpec.describe Hyperb::Services do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @base_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/services'
  end

  describe '#inspect_service' do

    it 'should raise ArgumentError when name is missing' do
      expect { @client.inspect_service }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + '/service1'

      stub_request(:get, path)
      .to_return(body: fixture('./inspect_service.json'))

      @client.inspect_service(name: 'service1')
      expect(a_request(:get, path)).to have_been_made
    end

    it 'return correct attrs' do
      path = @base_path + '/service1'

      stub_request(:get, path)
      .to_return(body: fixture('./inspect_service.json'))

      s = @client.inspect_service(name: 'service1')
      expect(s.is_a?(Hash)).to be true
    end
  end

  describe '#services' do

    it 'request to the correct path should be made' do
      path = @base_path

      stub_request(:get, path)
      .to_return(body: fixture('./services.json'))

      @client.services
      expect(a_request(:get, path)).to have_been_made
    end

    it 'return correct attrs' do
      path = @base_path

      stub_request(:get, path)
      .to_return(body: fixture('./services.json'))

      s = @client.services
      expect(s.is_a?(Array)).to be true
    end
  end

  describe '#remove_service' do

    it 'should raise ArgumentError when name is not provided' do
      expect { @client.remove_service }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + '/name'

      stub_request(:delete, path)
      .to_return(body: '')

      @client.remove_service(name: 'name')
      expect(a_request(:delete, path)).to have_been_made
    end

    it 'request to the correct path should be made with keep' do
      path = @base_path + '/name?keep=true'

      stub_request(:delete, path)
      .to_return(body: '')

      @client.remove_service(name: 'name', keep: true)
      expect(a_request(:delete, path)).to have_been_made
    end

  end

  describe '#create_service' do

    it 'should raise ArgumentError when name is not provided' do
      expect { @client.create_service image: 'nginx', labels: {} }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when image is not provided' do
      expect { @client.create_service name: 'srvc1', service_port: 80, labels: {} }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when service_port is not provided' do
      expect { @client.create_service }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when replicas is not provided' do
      expect { @client.create_service name: 'name1', image: 'img' }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when labels is not provided' do
      expect { @client.create_service }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made with name' do
      path = @base_path + '/create'
      body = {
        serviceport: 80,
        name: 'name1',
        image: 'nginx',
        replicas: 2,
        containerport: 80,
        labels: {}
      }
      stub_request(:post, path)
      .with(body: body)
      .to_return(body: fixture('create_service.json'))

      @client.create_service(body)
      expect(a_request(:post, path)).to have_been_made
    end

    it 'correct request should be made with entrypoint' do
      path = @base_path + '/create'
      body = {
        serviceport: 80,
        name: 'name1',
        image: 'nginx',
        replicas: 2,
        entrypoint: 'entry.sh',
        containerport: 80,
        labels: {}
      }
      stub_request(:post, path)
      .with(body: body)
      .to_return(body: fixture('create_service.json'))

      @client.create_service(body)
      expect(a_request(:post, path)).to have_been_made
    end

    it 'correct request should be made with cmd' do
      path = @base_path + '/create'
      body = {
        serviceport: 80,
        name: 'name1',
        image: 'nginx',
        replicas: 2,
        cmd: 'echo 1',
        containerport: 80,
        labels: {}
      }
      stub_request(:post, path)
      .with(body: body)
      .to_return(body: fixture('create_service.json'))

      @client.create_service(body)
      expect(a_request(:post, path)).to have_been_made
    end

    it 'correct request should be made with env' do
      path = @base_path + '/create'
      body = {
        serviceport: 80,
        name: 'name1',
        image: 'nginx',
        replicas: 2,
        env: ['ENV=123'],
        containerport: 80,
        labels: {}
      }
      stub_request(:post, path)
      .with(body: body)
      .to_return(body: fixture('create_service.json'))

      @client.create_service(body)
      expect(a_request(:post, path)).to have_been_made
    end

    it 'correct request should be made with protocol' do
      path = @base_path + '/create'
      body = {
        serviceport: 80,
        name: 'name1',
        image: 'nginx',
        replicas: 2,
        protocol: 'https',
        containerport: 80,
        labels: {}
      }
      stub_request(:post, path)
      .with(body: body)
      .to_return(body: fixture('create_service.json'))

      @client.create_service(body)
      expect(a_request(:post, path)).to have_been_made
    end

    it 'correct request should be made with algorithm' do
      path = @base_path + '/create'
      body = {
        serviceport: 80,
        name: 'name1',
        image: 'nginx',
        replicas: 2,
        containerport: 80,
        algorithm: 'roundrobin',
        labels: {}
      }
      stub_request(:post, path)
      .with(body: body)
      .to_return(body: fixture('create_service.json'))

      @client.create_service(body)
      expect(a_request(:post, path)).to have_been_made
    end

    it 'correct request should be made with workingdir' do
      path = @base_path + '/create'
      body = {
        serviceport: 80,
        name: 'name1',
        workingdir: '/path',
        image: 'nginx',
        replicas: 2,
        containerport: 80,
        labels: {}
      }
      stub_request(:post, path)
      .with(body: body)
      .to_return(body: fixture('create_service.json'))

      @client.create_service(body)
      expect(a_request(:post, path)).to have_been_made
    end
  end
end
