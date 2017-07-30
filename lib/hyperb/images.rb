require 'hyperb/request'
require 'hyperb/image'
require 'json'

module Hyperb
	module Images

    # list images
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Image/list.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @return [Hyperb::Image] Array of Images.
    # @param params [Hash] A customizable set of params.
    # @option params [String] :all
    # TODO: @option params [String] :filter only return images with the specified name
    # TODO: @option params [Hash] :filters a JSON encoded value of the filters to process on the images list.
    # TODO: @option params filters [String] :dangling true/false
    def images(params = {})
      path = '/images/json'
      path.concat('?all=true') if params[:all]
      response = JSON.parse(Hyperb::Request.new(self, path, 'get', nil).perform)
      response.map { |image| Hyperb::Image.new(image) }
    end

    def create_image(name)
      res = Hyperb::Request.new(self, 'post', '/images').perform
    end

    def remove_image(name)
      res = Hyperb::Request.new(self, 'delete', '/images').perform
    end
  end

end