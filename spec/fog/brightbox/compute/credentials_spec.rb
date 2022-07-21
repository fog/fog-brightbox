require "spec_helper"

describe Fog::Brightbox::Compute, "#credentials" do
  describe "when 2FA support is disabled" do
    before do
      @options = {
        brightbox_client_id: "app-12345",
        brightbox_secret: "1234567890",
        brightbox_username: "jason.null@brightbox.com",
        brightbox_password: "HR4life",
        brightbox_one_time_password: "123456"
      }
      @service = Fog::Brightbox::Compute.new(@options)
    end

    it "does not add passed OTP to credentials" do
      assert_kind_of Fog::Brightbox::OAuth2::CredentialSet, @service.credentials
      assert_nil @service.credentials.one_time_password
    end
  end

  describe "with 2FA support is enabled" do
    before do
      @expected_otp = "123456"
      @options = {
        brightbox_client_id: "app-12345",
        brightbox_secret: "1234567890",
        brightbox_username: "jason.null@brightbox.com",
        brightbox_password: "HR4life",
        brightbox_support_two_factor: true,
        brightbox_one_time_password: @expected_otp
      }
      @service = Fog::Brightbox::Compute.new(@options)
    end

    it "adds passed OTP to credentials" do
      assert_kind_of Fog::Brightbox::OAuth2::CredentialSet, @service.credentials
      assert @expected_otp, @service.credentials.one_time_password
    end
  end
end
