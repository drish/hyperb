module Hyperb
  # representation of Hyper errors
  class Error < StandardError

    attr_reader :code, :msg

    # 4xx HTTP status code
    ClientError = Class.new(self)

    # 5xx HTTP status code
    ServerError = Class.new(self)

    # code 400
    BadRequest = Class.new(ClientError)

    # code 401
    Unauthorized = Class.new(ClientError)

    # code 404
    NotFound = Class.new(ClientError)

    # code 409
    Conflict = Class.new(ClientError)

    # code 500
    InternalServerError = Class.new(ServerError)

    ERRORS = {
      400 => Hyperb::Error::BadRequest,
      401 => Hyperb::Error::Unauthorized,
      404 => Hyperb::Error::NotFound,
      409 => Hyperb::Error::Conflict,
      500 => Hyperb::Error::InternalServerError
    }.freeze

    def initialize(msg, code)
      super(msg)
      @code = code
    end
  end
end