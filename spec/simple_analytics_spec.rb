require 'spec_helper'

describe SimpleAnalytics::Api do
  STUB_URL = "https://www.googleapis.com/analytics/v3/data/ga?dimensions=ga:country&end-date=2012-01-10&ids=ga:id&metrics=ga:visitors&start-date=2012-01-01"

  REQUEST_BODY = {
    'accountType' => 'GOOGLE',
    'source' => 'djo-simple_analytics-001',
    'service' => 'analytics',
    'Email' => 'user@gmail.com',
    'Passwd' => 'password'
  }

  PROPERTIES = {
    'ids' => 'ga:id',
    'metrics' => 'ga:visitors',
    'dimensions' => 'ga:country',
    'start-date' => '2012-01-01',
    'end-date' => '2012-01-10'
  }

  before do
    @auth_request = stub_request(:post, 'https://www.google.com/accounts/ClientLogin').
      with(:body => REQUEST_BODY).
      to_return(:status => 200, :body => "AUTH=secret\n")
  end

  describe '.authenticate' do
    it "requests authentication" do
      SimpleAnalytics::Api.authenticate('user@gmail.com', 'password')
      @auth_request.should have_been_requested
    end

    it 'fetches an auth token' do
      analytics = SimpleAnalytics::Api.authenticate('user@gmail.com', 'password')
      analytics.auth_token.should eq('secret')
    end
  end

  describe '#fetch' do
    before { stub_analytics_request }

    let(:analytics) { SimpleAnalytics::Api.authenticate('user@gmail.com', 'password') }
    let(:properties) { PROPERTIES }

    it 'raises an argument error without requried properties' do
      expect {
        analytics.fetch('ids' => 'ga:xxx')
      }.to raise_error(ArgumentError)
    end

    it 'fetches rows' do
      rows = analytics.fetch(properties)
      rows.should eq([[ "United States", "73834"], ["Ukraine", "15726"]])
      analytics.rows.should eq([[ "United States", "73834"], ["Ukraine", "15726"]])
    end

    it 'sets column headers' do
      rows = analytics.fetch(properties)
      rows.should eq([[ "United States", "73834"], ["Ukraine", "15726"]])
      analytics.rows.should eq([[ "United States", "73834"], ["Ukraine", "15726"]])
    end

    it 'raises not successful response error' do
      stub_analytics_request(:status => 403, :code_type => Net::HTTPForbidden)

      expect {
        analytics.fetch(properties)
      }.to raise_error(SimpleAnalytics::NotSuccessfulResponseError)
    end

    def stub_analytics_request(response = {})
      data = {
        :body => { :rows => [[ "United States", "73834"], ["Ukraine", "15726"]] }.to_json,
        :status => 200,
        :code_type => Net::HTTPOK
      }

      stub_request(:get, STUB_URL).
        with(:headers => { 'Authorization'=>'GoogleLogin auth=secret', 'Gdata-Version'=>'3' }).
        to_return(data.merge(response))
    end
  end
end
