require "minitest/autorun"
require "webmock/minitest"
require "fog/brightbox"

describe Fog::Storage::Brightbox do
  let(:valid_auth_response) do
    {
      :status => 200,
      :body => "Authenticated",
      :headers => {
        "X-Storage-Url"=>"https://files.gb1.brightbox.com:443/v1/acc-12345",
        "Content-Length"=>"13",
        "X-Storage-Token"=>"c1236c8c34d668df497c06075d8a76a79c6fdd0d",
        "Content-Type"=>"text/plain",
        "X-Auth-Token"=>"c1236c8c34d668df497c06075d8a76a79c6fdd0d",
        "X-Trans-Id"=>"txcb228b8b9bfe4d5184828-0053568313",
        "Date"=>"Tue, 22 Apr 2014 14:56:20 GMT"
      }
    }
  end
  let(:config) { Fog::Brightbox::Config.new(settings) }
  let(:service) { Fog::Storage::Brightbox.new(config) }

  describe "when created without required arguments" do
    it "raises an error" do
      Fog.stub :credentials, {} do
        assert_raises ArgumentError do
          Fog::Storage::Brightbox.new({})
        end
      end
    end
  end

  describe "when created with a Config object" do
    let(:settings) do
      {
        :brightbox_client_id => "cli-12345",
        :brightbox_secret => "1234567890"
      }
    end

    it "does not error" do
      service
      pass
    end
  end

  describe "when created with Config missing required settings" do
    let(:settings) { {} }

    it "raises ArgumentError" do
      assert_raises ArgumentError do
        Fog::Storage::Brightbox.new(config)
      end
    end
  end

  describe "when created with a viable config" do
    let(:settings) do
      {
        :brightbox_client_id => "cli-12345",
        :brightbox_secret => "fdkls"
      }
    end

    before do
      stub_request(:get, "https://files.gb1.brightbox.com/v1").to_return(valid_auth_response)
    end

    it "requires a call to authenticate" do
      assert service.needs_to_authenticate?
    end

    it "requires a call to discover management_url" do
      assert_nil service.management_url
    end

    it "can authenticate" do
      service.authenticate
      assert_equal "https://files.gb1.brightbox.com/v1/acc-12345", service.management_url.to_s
    end
  end

  describe "when created with bad credentials" do
    let(:settings) do
      {
        :brightbox_client_id => "cli-12345",
        :brightbox_secret => "wrong"
      }
    end

    it "fails to authenticate" do
      response =  {
        :body=>"Bad URL",
        :headers=>
        {"Content-Length"=>"7",
         "Content-Type"=>"text/html; charset=UTF-8",
         "X-Trans-Id"=>"txab03ff4864ff42989f4a1-0053568282",
         "Date"=>"Tue, 22 Apr 2014 14:53:54 GMT"},
         :status=>412
      }
      stub_request(:get, "https://files.gb1.brightbox.com/v1").to_return(response)

      service.authenticate
      assert_nil service.management_url
    end
  end

  describe "when configured scoped to a specific account" do
    let(:settings) do
      {
        :brightbox_client_id => "app-12345",
        :brightbox_secret => "12345",
        :brightbox_username => "user@example.com",
        :brightbox_password => "abcde",
        :brightbox_account => "acc-abcde"
      }
    end

    before do
      stub_request(:get, "https://files.gb1.brightbox.com/v1").to_return(valid_auth_response)
    end

    it "uses the configured account" do
      assert service.authenticate
      assert_equal "acc-abcde", service.account
    end
  end

  describe "when account is not configured" do
    let(:settings) do
      {
        :brightbox_client_id => "app-12345",
        :brightbox_secret => "12345",
        :brightbox_username => "user@example.com",
        :brightbox_password => "abcde"
      }
    end

    before do
      stub_request(:get, "https://files.gb1.brightbox.com/v1").to_return(valid_auth_response)
    end

    it "extracts the account from the management URL" do
      assert service.authenticate
      assert_equal "acc-12345", service.account
    end
  end

  describe "when configured with existing token" do
    let(:settings) do
      {
        :brightbox_client_id => "app-12345",
        :brightbox_secret => "12345",
        :brightbox_access_token => "1234567890abcdefghijklmnopqrstuvwxyz",
        :brightbox_refresh_token => "1234567890abcdefghijklmnopqrstuvwxyz"
      }
    end

    it "does not need to authenticate" do
      refute service.needs_to_authenticate?
    end

    it "requires a call to discover management_url" do
      assert_nil service.management_url
    end
  end

  describe "when configured with tokens and management_url" do
    let(:settings) do
       {
        :brightbox_client_id => "app-12345",
        :brightbox_secret => "12345",
        :brightbox_access_token => "1234567890abcdefghijklmnopqrstuvwxyz",
        :brightbox_refresh_token => "1234567890abcdefghijklmnopqrstuvwxyz",
        :brightbox_storage_management_url => "https://files.gb2.brightbox.com/v1/acc-12345"
      }
    end

    it "does not need to authenticate" do
      refute service.needs_to_authenticate?
    end

    it "uses configured management_url" do
      assert_equal "https://files.gb2.brightbox.com/v1/acc-12345", service.management_url.to_s
    end

    it "keeps setting after authentication" do
      stub_request(:get, "https://files.gb1.brightbox.com/v1").to_return(valid_auth_response)
      config.expire_tokens!
      service.authenticate
      assert_equal "https://files.gb2.brightbox.com/v1/acc-12345", service.management_url.to_s
    end
  end

  describe "when configured with expired tokens" do
    let(:settings) do
       {
        :brightbox_client_id => "app-12345",
        :brightbox_secret => "12345",
        :brightbox_access_token => "1234567890abcdefghijklmnopqrstuvwxyz",
        :brightbox_refresh_token => "1234567890abcdefghijklmnopqrstuvwxyz",
        :brightbox_storage_management_url => "https://files.gb2.brightbox.com/v1/acc-12345",
        :brightbox_token_management => false
      }
    end

    before do
      # Ongoing request but tokens are expired
      stub_request(:get, "https://files.gb2.brightbox.com/v1/acc-12345/fnord").
        to_return(:status => 401,
                  :body => "Authentication required",
                  :headers => { "Content-Type" => "text/plain" })
    end

    let(:params) { { :expects => [200], :path => "fnord" } }

    it "raises Fog::Brightbox::Storage::AuthenticationRequired" do
      assert_raises(Fog::Brightbox::Storage::AuthenticationRequired) { service.request(params) }
    end
  end

  describe "when configured with user details and expired tokens" do
    let(:settings) do
       {
        :brightbox_client_id => "app-12345",
        :brightbox_secret => "12345",
        :brightbox_username => "user@example.com",
        :brightbox_password => "12345",
        :brightbox_access_token => "1234567890abcdefghijklmnopqrstuvwxyz",
        :brightbox_refresh_token => "1234567890abcdefghijklmnopqrstuvwxyz",
        :brightbox_storage_url => "https://files.gb2.brightbox.com",
        :brightbox_storage_management_url => "https://files.gb2.brightbox.com/v1/acc-12345"
      }
    end

    before do
      # Ongoing request but tokens are expired
      stub_request(:get, "https://files.gb2.brightbox.com/v1/acc-12345/fnord").
        with(:headers => { "X-Auth-Token" => "1234567890abcdefghijklmnopqrstuvwxyz" }).
        to_return(:status => 401,
                  :body => "Authentication required",
                  :headers => { "Content-Type" => "text/plain" })

      # The reauthentication
      stub_request(:get, "https://files.gb2.brightbox.com/v1").
        with(:headers => { "X-Auth-User" => "user@example.com", "X-Auth-Key" => "12345" }).
        to_return(valid_auth_response)

      # Repeated request
      stub_request(:get, "https://files.gb2.brightbox.com/v1/acc-12345/fnord").
        with(:headers => { "X-Auth-Token" => "c1236c8c34d668df497c06075d8a76a79c6fdd0d" }).
        to_return(:status => 200)
    end

    let(:params) { { :expects => [200], :path => "fnord" } }

    it "authenticates again and retries" do
      service.request(params)
      pass
    end
  end

  describe "when configured with client credentials" do
    let(:settings) do
      {
        :brightbox_client_id => "cli-12345",
        :brightbox_secret => "12345"
      }
    end

    before do
      # Initial authentication
      stub_request(:get, "https://files.gb1.brightbox.com/v1").
        with(:headers => {"X-Auth-Key" => "12345", "X-Auth-User" => "cli-12345"}).
        to_return(valid_auth_response)

      stub_request(:get, "https://files.gb1.brightbox.com/v1/acc-12345/fnord").
        with(:headers => { "X-Auth-Token" => "c1236c8c34d668df497c06075d8a76a79c6fdd0d" }).
        to_return(:status => 200)
    end

    let(:params) { { :expects => [200], :path => "fnord" } }

    it "authenticates again and retries" do
      service.request(params)
      pass
    end
  end
end
