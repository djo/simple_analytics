require 'simple_analytics/version'
require 'json'
require 'google_client_login'

module SimpleAnalytics
  # Required query parameters are used to configure which data to return from Google Analytics.
  REQUIRED_PROPERTIES = ['ids', 'start-date', 'end-date', 'metrics']
  API_URL = 'https://www.googleapis.com/analytics/v3/data/ga'

  class NotSuccessfulResponseError < RuntimeError; end

  class Api
    attr_accessor :auth_token

    # +rows+ is a 2-dimensional array of strings, each string represents a value in the table.
    # +body+ is the data in response body.
    attr_reader :rows, :body

    def self.authenticate(username, password, options = {})
      analytics = new(username, password, options)
      analytics.authenticate
      analytics
    end

    def initialize(username, password, options = {})
      @username = username
      @password = password
      @options = options
    end

    def authenticate
      login_service = ::GoogleClientLogin::GoogleAuth.new(client_options)
      login_service.authenticate(@username, @password, @options[:captcha_response])
      @auth_token = login_service.auth
    end

    def fetch(properties)
      check_properties(properties)

      uri = URI.parse(API_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      headers = { 'Authorization' => "GoogleLogin auth=#{@auth_token}", 'GData-Version' => '3' }
      response = http.get("#{uri.path}?#{query_string(properties)}", headers)
      raise NotSuccessfulResponseError.new, response.body if response.code_type != Net::HTTPOK

      @body = JSON.parse(response.body)
      @rows = @body['rows']
    end

    private

    def client_options
      {
        :service     => 'analytics',
        :accountType => (@options[:accountType] || 'GOOGLE'),
        :source      => (@options[:source] || 'djo-simple_analytics-001')
      }
    end

    def check_properties(properties)
      required = properties.keys.map(&:to_s) & REQUIRED_PROPERTIES
      if required.size != REQUIRED_PROPERTIES.size
        raise ArgumentError, "Properties: #{REQUIRED_PROPERTIES.join(', ')} are required."
      end
    end

    def query_string(properties)
      properties.map { |k, v| "#{k}=#{escape v}" }.sort.join('&')
    end

    def escape(property)
      URI.escape(property.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
  end
end
