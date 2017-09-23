require 'helper'
require 'http'

RSpec.describe Hyperb::Compose do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @base_path = "#{base_url(@client)}/compose/"
  end

  describe '#compose_down' do

    it 'should raise ArgumentError when project is not provided' do
      expect { @client.compose_down }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + 'down?project=app'
      stub_request(:post, path)
      .to_return(body: "")

      @client.compose_down(project: 'app')
      expect(a_request(:post, path)).to have_been_made
    end

    it 'request to the correct path should be made with rmi' do
      path = @base_path + 'down?project=app&rmi=all'
      stub_request(:post, path)
      .to_return(body: "")

      @client.compose_down(project: 'app', rmi: 'all')
      expect(a_request(:post, path)).to have_been_made
    end

    it 'request to the correct path should be made with rmi' do
      path = @base_path + 'down?project=app&rmi=local'
      stub_request(:post, path)
      .to_return(body: "")

      @client.compose_down(project: 'app', rmi: 'local')
      expect(a_request(:post, path)).to have_been_made
    end

    it 'request to the correct path should be made with rmorphans' do
      path = @base_path + 'down?project=app&rmorphans=true'
      stub_request(:post, path)
      .to_return(body: "")

      @client.compose_down(project: 'app', rmorphans: true)
      expect(a_request(:post, path)).to have_been_made
    end

    it 'request to the correct path should be made with rmorphans' do
      path = @base_path + 'down?project=app&vol=true'
      stub_request(:post, path)
      .to_return(body: "")

      @client.compose_down(project: 'app', vol: true)
      expect(a_request(:post, path)).to have_been_made
    end

  end

  describe '#compose_create' do

    before do
      @serviceconfigs = {
        'web': {
          'image': 'rails'
        },
        'db': {
          'image': 'mariadb'
        }
      }
    end

    it 'should raise ArgumentError when project is not provided' do
      expect { @client.compose_create }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + 'create?project=app'
      stub_request(:post, path)
      .to_return(body: fixture('compose_up.json'))

      @client.compose_create(project: 'app', serviceconfigs: @serviceconfigs)
      expect(a_request(:post, path)).to have_been_made
    end
  end

  describe '#compose_up' do

    before do
      @serviceconfigs = {
        'web': {
          'image': 'rails'
        },
        'db': {
          'image': 'mariadb'
        }
      }
    end

    it 'should raise ArgumentError when project is not provided' do
      expect { @client.compose_up }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + 'up?project=app'
      stub_request(:post, path)
      .to_return(body: fixture('compose_up.json'))

      @client.compose_up(project: 'app', serviceconfigs: @serviceconfigs)
      expect(a_request(:post, path)).to have_been_made
    end
  end

  describe '#compose_rm' do

    it 'should raise ArgumentError when project is not provided' do
      expect { @client.compose_rm }.to raise_error(ArgumentError)
    end

    it 'correct request should be made' do
      path = @base_path + 'rm?project=blog'

      stub_request(:post, path)
      .to_return(body: fixture('compose_rm.json'))

      @client.compose_rm(project: 'blog')
      expect(a_request(:post, path)).to have_been_made
    end

    it 'correct request should be made with rmvol' do
      path = @base_path + 'rm?project=blog&rmvol=true'

      stub_request(:post, path)
      .to_return(body: fixture('compose_rm.json'))

      @client.compose_rm(project: 'blog', rmvol: true)
      expect(a_request(:post, path)).to have_been_made
    end

  end
end
