require 'spec_helper'

describe SimpleAnalytics::Api do

  describe ".authenticate" do
    before do
      @auth_request = stub_request(:post, "https://www.google.com/accounts/ClientLogin").
        with(:body => { "accountType" => "GOOGLE", "source" => "djo-simple_analytics-001", "service" => "analytics", "Email"=>"user@gmail.com", "Passwd" => "password" }).
        to_return(:status => 200, :body => "AUTH=secret\n")
    end

    it "requests authentication" do
      SimpleAnalytics::Api.authenticate('user@gmail.com', 'password')
      @auth_request.should have_been_requested
    end

    it "fetches an auth token" do
      analytics = SimpleAnalytics::Api.authenticate('user@gmail.com', 'password')
      analytics.auth_token.should eq('secret')
    end
  end

end
