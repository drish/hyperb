require 'helper'
require 'http'

RSpec.describe Hyperb::Images do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @images_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/images/json'
    @create_image_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/images/create?fromImage=busybox'
    @remove_image_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/images/busybox'
  end

  describe '#images' do

    before do
      stub_request(:get, @images_path)
      .to_return(body: fixture('images.json'))
    end

    it 'request to the correct path should be made' do
      @client.images
      expect(a_request(:get, @images_path)).to have_been_made
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

  describe '#create_image' do

    before do
      stub_request(:post, @create_image_path)
      .to_return(body: fixture('create_image.json'))
    end

    it 'request to the correct path should be made' do
      @client.create_image from_image: 'busybox'
      expect(a_request(:post, @create_image_path)).to have_been_made
    end

    it 'should raise ArgumentError if argument missing' do
      expect { @client.create_image wrong_arg: 'busybox' }.to raise_error(ArgumentError)
    end

     it 'return http:response' do
       res = @client.create_image from_image: 'busybox'
       expect(res).to be_a HTTP::Response::Body
     end
  end

  describe '#remove_image' do

    before do
      stub_request(:delete, @remove_image_path)
      .to_return(body: fixture('remove_image.json'))
    end

    it 'request to the correct path should be made' do
      @client.remove_image name: 'busybox'
      expect(a_request(:delete, @remove_image_path)).to have_been_made
    end

    it 'return an array of symbolized hashes' do
      res = @client.remove_image(name: 'busybox')
      expect(res).to be_a Array
      res.each do |r|
        r.keys.each { |k| expect(k).to be_a(Symbol) }
      end
    end
  end

end
