require "spec_helper"

describe Fog::Brightbox::Compute, "#two_factor?" do
  describe "when omitted" do
    before do
      @options = {
        brightbox_client_id: "app-12345",
        brightbox_secret: "1234567890",
        brightbox_username: "jason.null@brightbox.com",
        brightbox_password: "HR4life"
      }
      @service = Fog::Brightbox::Compute.new(@options)
    end

    it do
      refute @service.two_factor?
    end
  end

  describe "when disabled" do
    before do
      @options = {
        brightbox_client_id: "app-12345",
        brightbox_secret: "1234567890",
        brightbox_username: "jason.null@brightbox.com",
        brightbox_password: "HR4life",
        brightbox_support_two_factor: false
      }
      @service = Fog::Brightbox::Compute.new(@options)
    end

    it do
      refute @service.two_factor?
    end
  end

  describe "when enabled" do
    before do
      @options = {
        brightbox_client_id: "app-12345",
        brightbox_secret: "1234567890",
        brightbox_username: "jason.null@brightbox.com",
        brightbox_password: "HR4life",
        brightbox_support_two_factor: true
      }
      @service = Fog::Brightbox::Compute.new(@options)
    end

    it do
      assert @service.two_factor?
    end
  end
end
