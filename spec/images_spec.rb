require 'helper'

RSpec.describe Hyperb::Images do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/images/json'
  end

  describe '#images' do

    before do
      stub_request(:get, @path)
      .to_return(body: fixture('images.json'))
    end

    it 'request to the correct path should be mae' do
      @client.images
      expect(a_request(:get, @path)).to have_been_made
    end

    it 'return array of images' do
      images = @client.images
      expect(images).to be_a Array
      expect(images[0]).to be_a Hyperb::Image
    end

    it 'correct attrs' do
      @client.images.each do |img|
        expect(img.id).to be_a String
        expect(img.created).to be_a Fixnum
      end
    end

   end
end
