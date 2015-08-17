require "spec_helper"

describe Fog::Brightbox::OAuth2::RefreshTokenStrategy do
  before do
    @client_id = "app-12345"
    @client_secret = "__mashed_keys_123__"
    @credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret)
    @strategy = Fog::Brightbox::OAuth2::GrantTypeStrategy.new(@credentials)
  end

  it "tests #respond_to?(:authorization_body_data) returns true"  do
    assert @strategy.respond_to?(:authorization_body_data)
  end
end
