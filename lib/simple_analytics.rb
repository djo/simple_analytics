require "simple_analytics/version"
require "google_client_login"

module SimpleAnalytics

  class Api
    attr_reader :auth_token

    def self.authenticate(username, password, options = {})
      new(username, password, options).tap do |analytics|
        analytics.authenticate
      end
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

    private

    def client_options
      { :service     => 'analytics',
        :accountType => (@options[:accountType] || 'GOOGLE'),
        :source      => (@options[:source] || 'djo-simple_analytics-001') }
    end
  end

end
