require 'helper'
require 'http'

RSpec.describe Hyperb::Images do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')
    @images_path = "#{base_url(@client)}/images/json?all=true"
    @create_image_path = "#{base_url(@client)}/images/create?fromImage=busybox"
    @remove_image_path = "#{base_url(@client)}/images/busybox"
    @inspect_image_path = "#{base_url(@client)}/images/busybox/json"
  end

  describe '#images' do

    before do
      stub_request(:get, @images_path)
      .to_return(body: fixture('images.json'))
    end

    it 'request to the correct path should be made, all=true by default' do
      @client.images
      expect(a_request(:get, @images_path)).to have_been_made
    end

    it 'request to the correct path should be made with filter=name' do
      stub_request(:get, @images_path + '&filter=busybox')
      .to_return(body: fixture('images.json'))

      @client.images(filter: 'busybox')
      expect(a_request(:get, @images_path + '&filter=busybox')).to have_been_made
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

     it 'create image with auth_object' do
       p = "#{base_url(@client)}/images/create?fromImage=gcr.io/private/custom_busybox"
       stub_request(:post, p)
       .to_return(body: fixture('create_image.json'))

       x_registry_auth = { username: 'test', password: fixture('auth_obj.json'), email: 'test@t.com' }
       @client.create_image from_image: 'gcr.io/private/custom_busybox', x_registry_auth: x_registry_auth

       expect(a_request(:post, p)).to have_been_made
     end

  end

  describe '#remove_image' do

    before do
      stub_request(:delete, @remove_image_path)
      .to_return(body: fixture('remove_image.json'))
    end

    it 'should raise ArgumentError when name is not provided' do
      expect { @client.remove_image }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      @client.remove_image name: 'busybox'
      expect(a_request(:delete, @remove_image_path)).to have_been_made
    end

    it 'request to the correct path should be made with force=true' do
      stub_request(:delete, @remove_image_path + '?force=true')
      .to_return(body: fixture('remove_image.json'))

      @client.remove_image(name: 'busybox', force: true)
      expect(a_request(:delete, @remove_image_path + '?force=true')).to have_been_made
    end

    it 'return an array of symbolized hashes' do
      res = @client.remove_image(name: 'busybox')
      expect(res).to be_a Array
      res.each do |r|
        r.keys.each { |k| expect(k).to be_a(Symbol) }
      end
    end
  end

  describe '#inspect_image' do

    before do
      stub_request(:get, @inspect_image_path)
      .to_return(body: fixture('inspect_image.json'))
    end

    it 'should raise ArgumentError when name is not provided' do
      expect { @client.inspect_image }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      @client.inspect_image name: 'busybox'
      expect(a_request(:get, @inspect_image_path)).to have_been_made
    end

    it 'return a hash with symbolized attrs' do
      res = @client.inspect_image(name: 'busybox')
      expect(res).to be_a Hash
      expect(res.has_key?(:id)).to be true
      expect(res.has_key?(:container)).to be true
      expect(res.has_key?(:comment)).to be true
    end
  end

end
