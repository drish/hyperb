require 'helper'
require 'http'

RSpec.describe Hyperb::Snapshots do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @base_path = "#{base_url(@client)}/snapshots"
  end

  describe '#create_snapshot' do

    it 'should raise ArgumentError if volume argument missing' do
      expect { @client.create_snapshot name: 'name' }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError if name argument missing' do
      expect { @client.create_snapshot volume: 'volume-id' }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      path = @base_path + '/create?volume=volumee&name=namee'
      stub_request(:post, path)
      .to_return(body: fixture('create_snapshot.json'))

      @client.create_snapshot volume: 'volumee', name: 'namee'
      expect(a_request(:post, path)).to have_been_made
    end
  end
end
