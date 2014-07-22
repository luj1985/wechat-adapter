require 'restclient'

module Wechat
  module Adapter
    class TokenExpiredError < StandardError; end

    class ResponseError < StandardError
      attr_reader :error_code
      def initialize(code, message)
        error_code = code
        super "#{code} (#{message})"
      end
    end

    class WechatAPI
      def initialize appid, appsecret, base = 'https://api.weixin.qq.com/cgi-bin'
        @appid, @appsecret, @base = appid, appsecret, base
      end

      def handle_err_response values
        code = values["errcode"]
        return if code == 0
        raise TokenExpiredError if [42001, 40014].include? code
        raise ResponseError.new(code, values['errmsg'])
      end

      def raw_json_request method, path, params = {}, payload = nil
        params[:access_token] = @access_token if @access_token
        url = "#{@base}/#{path}"

        response = ::RestClient::Request.execute(
          :method => method, 
          :url => url, 
          :headers => { :params => params }, 
          :payload => (payload.to_json if payload),
          :content_type => :json)

        values = JSON.parse(response.body)
        values["errcode"] ? handle_err_response(values) : values
      end

      def json_request *args, &block
        begin
          aquire_access_token unless @access_token
          response = raw_json_request *args, &block
        rescue TokenExpiredError
          aquire_access_token
          retry
        end
      end

      def aquire_access_token
        values = raw_json_request :get, 'token', { 
          :grant_type => 'client_credential',
          :appid => @appid,
          :secret => @appsecret
        }
        @access_token = values["access_token"]
      end

      def post path, options = {}, payload = nil
        json_request(:post, path, options, payload)
      end

      def get path, options = {}
        json_request(:get, path, options)
      end
    end
  end
end