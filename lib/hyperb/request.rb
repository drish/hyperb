require 'hyperb/error'
require 'openssl'
require 'time'
require 'uri'
require 'http'
require 'digest'
require 'json'

module Hyperb

  # wraps all requests, performing aws4 signature
  class Request
    FMT = '%Y%m%dT%H%M%SZ'.freeze
    VERSION = 'v1.23'.freeze

    SERVICE = 'hyper'.freeze
    ALGORITHM = 'HYPER-HMAC-SHA256'.freeze
    KEYPARTS_REQUEST = 'hyper_request'.freeze

    attr_accessor :verb, :path, :client, :date, :headers, :signed

    def initialize(client, path, query = {}, verb = 'GET', body = '', optional_headers = {})
      @client = client
      @path = VERSION + path
      @query = URI.encode_www_form(query)
      @body = body.empty? ? body : body.to_json
      @hashed_body = hexdigest(@body)
      @verb = verb.upcase
      @date = Time.now.utc.strftime(FMT)

      @host = "#{client.region}.hyper.sh".freeze
      @base_url = "https://#{@host}/".freeze

      @headers = {
        content_type: 'application/json',
        x_hyper_date: @date,
        host: @host,
        x_hyper_content_sha256: @hashed_body
      }
      @headers.merge!(optional_headers) unless optional_headers.empty?
      @signed = false
    end

    def perform
      sign unless signed
      final = @base_url + @path + '?' + @query
      options = {}
      options[:body] = @body unless @body.empty?
      response = HTTP.headers(@headers).public_send(@verb.downcase.to_sym, final, options)
      fail_or_return(response.code, response.body)
    end

    def fail_or_return(code, body)
      error = Hyperb::Error::ERRORS[code]
      raise(error.new(body, code)) if error
      body
    end

    # join all headers by `;`
    # ie:
    # content-type;x-hyper-hmac-sha256
    def signed_headers
      @headers.keys.sort.map { |header| header.to_s.tr('_', '-') }.join(';')
    end

    # sorts all headers, join them by `:`, and re-join by \n
    # ie:
    # content-type:application\nhost:us-west-1.hyper.sh
    def canonical_headers
      canonical = @headers.sort.map do |header, value|
        "#{header.to_s.tr('_', '-')}:#{value}"
      end
      canonical.join("\n") + "\n"
    end

    # creates Authoriatization header
    def sign
      credential = "#{@client.access_key}/#{credential_scope}"
      auth = "#{ALGORITHM} Credential=#{credential}, "
      auth += "SignedHeaders=#{signed_headers}, "
      auth += "Signature=#{signature}"
      @headers[:authorization] = auth
      @signed = true
    end

    # setup signature key
    # https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/index.html
    def signature
      k_date = hmac('HYPER' + @client.secret_key, @date[0, 8])
      k_region = hmac(k_date, client.region)
      k_service = hmac(k_region, SERVICE)
      k_credentials = hmac(k_service, KEYPARTS_REQUEST)
      hexhmac(k_credentials, string_to_sign)
    end

    def string_to_sign
      [ALGORITHM, @date, credential_scope, hexdigest(canonical_request)].join("\n")
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
        @date[0, 8],
        client.region,
        SERVICE,
        KEYPARTS_REQUEST
      ].join("/") # rubocop:disable StringLiterals
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

  # func requests are very simple, they do not require signing
  class FuncCallRequest

    attr_accessor :path, :query, :verb, :body, :headers

    def initialize(client, path, query = {}, verb = 'GET', body = '')
      @client = client

      @host = "#{client.region}.hyperfunc.io".freeze
      @base_url = "https://#{@host}/".freeze

      @path = path
      @verb = verb
      @query = URI.encode_www_form(query)
      @body = body.empty? ? body : body.to_json
      @headers = { content_type: 'application/json' }
    end

    def perform
      final_url = @base_url + @path + '?' + @query
      options = {}
      options[:body] = @body unless @body.empty?
      response = HTTP.headers(@headers).public_send(@verb.downcase.to_sym, final_url, options)
      fail_or_return(response.code, response.body)
    end

    def fail_or_return(code, body)
      error = Hyperb::Error::ERRORS[code]
      raise(error.new(body, code)) if error
      body
    end
  end
end
