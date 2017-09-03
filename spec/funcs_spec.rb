require 'helper'

RSpec.describe Hyperb::Funcs do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @funcs_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/funcs'
  end

  describe '#funcs' do

    before do
      stub_request(:get, @funcs_path)
      .to_return(body: fixture('funcs.json'))
    end

    it 'request to the correct path should be made' do
      @client.funcs
      expect(a_request(:get, @funcs_path)).to have_been_made
    end

    it 'return array of funcs' do
      funcs = @client.funcs
      expect(funcs).to be_a Array
      expect(funcs.first).to be_a Hyperb::Func
    end

    it 'correct attrs' do
      @client.funcs.each do |fn|

        expect(fn.name).to be_a String
        expect(fn.created).to be_a String
        expect(fn.container_size).to be_a String
        expect(fn.timeout).to be_a Fixnum
        expect(fn.uuid).to be_a String

        expect(fn.config).to be_a Hash
        expect(fn.config[:cmd]).to be_a Array
        expect(fn.config[:env]).to be_a Array
        expect(fn.config[:image]).to be_a String
        expect(fn.config[:stop_signal]).to be_a String

        expect(fn.host_config).to be_a Hash
        expect(fn.host_config[:network_mode]).to be_a String

        expect(fn.networking_config).to be_a Hash
        expect(fn.networking_config[:endpoints_config]).to be_a String
      end
    end
  end

  describe '#create_func' do

    before do
      stub_request(:post, @funcs_path + '/create')
      .to_return(body: fixture('create_func.json'))
    end

    it 'request to the correct path should be made' do

      params = {
        name: 'helloworld',
        config: {
          cmd: [
            'echo',
            'HelloWorld'
          ],
          image: 'ubuntu'
        }
      }

      @client.create_func(params)
      expect(a_request(:post, @funcs_path + '/create')
      .with(body:
        {
          'Name': 'helloworld',
          'Config':
            {
              'Cmd': ['echo', 'HelloWorld'],
              'Image': 'ubuntu'
            }
        })
      ).to have_been_made
    end
  end
end
