require 'openssl'
require 'time'

module Hyperb

  class Request

    FMT = '%Y%m%dT%H%M%SZ'
    VERSION = 'v1.23'
    HOST = 'us-west-1.hyper.sh'
    REGION = 'us-west-1'
    SERVICE = 'hyper'
    ALGORITHM = 'HYPER-HMAC-SHA256'
    KEYPARTS_REQUEST = 'hyper_request'
    BASE_URL = 'https://' + HOST + '/' + VERSION

    attr_accessor :verb, :uri, :client, :date, :headers

    def initialize(client, path, verb = 'GET', body = '')
      @client = client
      @path = path
      @body = body
      @verb = verb.upcase
      @date = Time.now.utc.strftime(FMT)
      @hashed_body = hash(body)
      @headers = {
        'content-type' => 'application/json',
        'x-hyper-date' => @date,
        'host' => HOST,
        'x-hyper-content-sha256' => @hashed_body
      }
    end

    def perform
      sign
      puts 'making request . . .'
    end

    def signed_headers
      @headers.keys.sort.join(";")
    end

    # sorts all headers, join them by `:`, and re-join by \n
    # ie:
    # content-type:application\nhost:us-west-1.hyper.sh
    def canonical_headers
      @headers.sort.map { |header| header.join(':') }.join("\n")
    end

    def sign
      credential = "#{@client.access_key}/#{credential_scope}"
      auth = "#{ALGORITHM} Credential=#{credential},SignedHeaders=#{signed_headers},Signature=#{signature}"
      puts credential
      puts auth
    end

    def signature
      hmac(signing_key, string_to_sign)
    end

    def string_to_sign
      [
        ALGORITHM,
        @date,
        credential_scope,
        hash(canonical_request())
      ].join("\n")
    end

    def signing_key
      k_date = hmac('HYPER' + @client.secret_key, @date)
      k_region = hmac(k_date, REGION)
      k_service = hmac(k_region, SERVICE)
      hmac(k_service, KEYPARTS_REQUEST)
    end

    def canonical_request
      [
        @verb,
        @path,
        @query,
        canonical_headers,
        signed_headers,
        @hashed_body
      ].join("\n")
    end

    def credential_scope
      [
        @date,
        REGION,
        SERVICE,
        KEYPARTS_REQUEST
      ].join('/')
    end

    def hmac(key, data)
      OpenSSL::HMAC.hexdigest(hash(''), key, data)
    end

    def hash(data)
      OpenSSL::Digest.new('sha256', data)
    end

  end
end