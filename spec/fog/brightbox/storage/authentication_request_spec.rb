require "minitest/autorun"
require "webmock/minitest"
require "fog/brightbox"

describe Fog::Brightbox::Storage::AuthenticationRequest do
  describe "when initialised with blank config" do
    before do
      stub_request(:get, "https://files.gb1.brightbox.com/v1").
        with(:headers => {
        "Host" => "files.gb1.brightbox.com:443",
        "X-Auth-User" => "",
        "X-Auth-Key" => ""
      }).to_return(:status => 412, :body => "Bad URL", :headers => {})
    end

    it "fails" do
      settings = {}
      @config = Fog::Brightbox::Config.new(settings)
      @request = Fog::Brightbox::Storage::AuthenticationRequest.new(@config)
      refute @request.authenticate
    end
  end

  describe "when initialised with API client details" do
    before do
      stub_request(:get, "https://files.gb1.brightbox.com/v1").
        with(:headers => {
          "Host" => "files.gb1.brightbox.com:443",
          "X-Auth-User" => "cli-12345",
          "X-Auth-Key" => "12345"
      }).to_return(:status => 200, :body => "Authenticated", :headers => {
        "X-Storage-Url" => "https://files.gb1.brightbox.com/v1/acc-12345",
        "X-Storage-Token" => "abcdefghijklmnopqrstuvwxyz1234567890",
        "X-Auth-Token" => "abcdefghijklmnopqrstuvwxyz1234567890",
        "Content-Type" => "text/plain"
      })
    end

    it "authenticates correctly" do
      settings = {
        :brightbox_client_id => "cli-12345",
        :brightbox_secret => "12345"
      }
      @config = Fog::Brightbox::Config.new(settings)
      @request = Fog::Brightbox::Storage::AuthenticationRequest.new(@config)
      assert @request.authenticate
    end
  end

  describe "when initialised with user details" do
    before do
      stub_request(:get, "https://files.gb1.brightbox.com/v1").
        with(:headers => {
          "Host" => "files.gb1.brightbox.com:443",
          "X-Auth-User" => "user@example.com",
          "X-Auth-Key" => "abcde"
      }).to_return(:status => 200, :body => "Authenticated", :headers => {
        "X-Storage-Url" => "https://files.gb1.brightbox.com/v1/acc-12345",
        "X-Storage-Token" => "abcdefghijklmnopqrstuvwxyz1234567890",
        "X-Auth-Token" => "abcdefghijklmnopqrstuvwxyz1234567890",
        "Content-Type" => "text/plain"
      })
    end

    it "authenticates correctly" do
      settings = {
        :brightbox_client_id => "app-12345",
        :brightbox_secret => "12345",
        :brightbox_username => "user@example.com",
        :brightbox_password => "abcde"
      }
      @config = Fog::Brightbox::Config.new(settings)
      @request = Fog::Brightbox::Storage::AuthenticationRequest.new(@config)
      assert @request.authenticate
    end
  end
end
