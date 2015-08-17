require "spec_helper"

describe Fog::Brightbox::OAuth2::UserCredentialsStrategy do
  before do
    @client_id     = "app-12345"
    @client_secret = "__mashed_keys_123__"
    @username      = "usr-12345"
    @password      = "__mushed_keys_321__"

    options = {
      :username => @username,
      :password => @password
    }

    @credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret, options)
    @strategy = Fog::Brightbox::OAuth2::UserCredentialsStrategy.new(@credentials)
  end

  it "tests #respond_to?(:authorization_body_data) returns true"  do
    assert @strategy.respond_to?(:authorization_body_data)
  end

  it "tests #authorization_body_data" do
    authorization_body_data = @strategy.authorization_body_data
    assert_equal "password", authorization_body_data["grant_type"]
    assert_equal @client_id, authorization_body_data["client_id"]
    assert_equal @username, authorization_body_data["username"]
    assert_equal @password, authorization_body_data["password"]
  end
end
