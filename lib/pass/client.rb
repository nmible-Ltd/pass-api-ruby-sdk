require 'singleton'

module PASS
  class Client
    include Singleton

    attr_reader :conn, :access_token, :refresh_token, :access_token_expiry, :refresh_token_expiry
    attr_accessor :debug

    def initialize
      @debug = false
      @endpoint = ENV['PASS_ENDPOINT']
      @conn = Faraday.new(
        url: @endpoint,
        headers: {'Content-Type': 'application/vnd.api+json'}
      ) do |faraday|
        faraday.request :json
        faraday.response :json, :parser_options => { :symbolize_names => true }
        faraday.response :raise_error
      end

      login_response = @conn.post 'users/login',
                                  {email: ENV['PASS_EMAIL'], password: ENV['PASS_PASSWORD']}


      @access_token = login_response.body[:data][:attributes][:access]
      @refresh_token = login_response.body[:data][:attributes][:refresh]

      # TODO: implement refresh behaviour - for now this is ok - the expiry time is 24 hours
      # Although in this case the refresh token expires in 48 hours

      @access_token_expiry = Time.at(JWT.decode(@access_token, nil, false)[0]["exp"])
      @refresh_token_expiry = Time.at(JWT.decode(@refresh_token, nil, false)[0]["exp"])
    end

    def authenticated?
      Time.now < access_token_expiry
    end

    def set_debug(debug_value)
      @debug = debug_value
    end

    def connection
      Faraday.new(
        url: @endpoint,
        headers: {'Content-Type': 'application/vnd.api+json', 'Authorization': "Bearer #{access_token}"}
      ) do |faraday|
        faraday.request :json
        faraday.response :json, :parser_options => { :symbolize_names => true }
        faraday.response :logger, nil, { headers: true, bodies: true, errors: true } if debug
      end
    end


  end
end
