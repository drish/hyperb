require 'openssl'
require 'time'
require 'uri'
require 'http'
require 'digest'

module Hyperb

  class Request

    FMT = '%Y%m%dT%H%M%SZ'.freeze
    VERSION = 'v1.23'.freeze
    HOST = 'us-west-1.hyper.sh'.freeze
    REGION = 'us-west-1'.freeze
    SERVICE = 'hyper'.freeze
    ALGORITHM = 'HYPER-HMAC-SHA256'.freeze
    KEYPARTS_REQUEST = 'hyper_request'.freeze
    BASE_URL = 'https://' + HOST + '/'

    attr_accessor :verb, :uri, :client, :date, :headers, :conn

    def initialize(client, uri, verb = 'GET', body = '')
      @client = client
      @uri = URI(VERSION + uri)
      @path = @uri.path
      @query = @uri.query
      @body = body
      @hashed_body = hexdigest(body)
      @verb = verb.upcase
      @date = Time.now.utc.strftime(FMT)
      @headers = {
        :content_type => 'application/json',
        :x_hyper_date => @date,
        :host => HOST,
        :x_hyper_content_sha256 => @hashed_body
      }
    end

    def perform
      sign
      response = HTTP.headers(@headers).public_send(:get, BASE_URL + @uri.to_s)
      puts response
      response.body
    end

    # join all headers sent by `;`
    # ie:
    # content-type;x-hyper-hmac-sha256
    def signed_headers
      @headers.keys.sort.map { |header| header.to_s.gsub('_', '-') }.join(';')
    end

    # sorts all headers, join them by `:`, and re-join by \n
    # ie:
    # content-type:application\nhost:us-west-1.hyper.sh
    def canonical_headers
      @headers.sort.map { |header, value| "#{header.to_s.gsub('_', '-')}:#{value}" }.join("\n") + "\n"
    end

    # creates Authoriatization header
    def sign
      credential = "#{@client.access_key}/#{credential_scope}"
      auth = "#{ALGORITHM} Credential=#{credential}, SignedHeaders=#{signed_headers}, Signature=#{signature}"
      @headers[:authorization] = auth
    end

    # setups signature key
    # https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/index.html
    def signature
      k_date = hmac('HYPER' + @client.secret_key, @date[0,8])
      k_region = hmac(k_date, REGION)
      k_service = hmac(k_region, SERVICE)
      k_credentials = hmac(k_service, 'hyper_request')
      hexhmac(k_credentials, string_to_sign)
    end

    def string_to_sign
      [
        ALGORITHM,
        @date,
        credential_scope,
        hexdigest(canonical_request)
      ].join("\n")
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
        @date[0,8],
        REGION,
        SERVICE,
        KEYPARTS_REQUEST
      ].join("/")
    end

    def hexdigest(value)
      Digest::SHA256.new.update(value).hexdigest
    end

    def hmac(key, value)
      OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, value)
    end

    def hexhmac(key, value)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), key, value)
    end

  end
end