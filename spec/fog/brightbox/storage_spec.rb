require "minitest/autorun"
require "fog/brightbox"

describe Fog::Brightbox::Storage do
  describe "when passed in configuration" do
    before do
      @options = {
        brightbox_client_id: "cli-12345",
        brightbox_secret: "1234567890",
        brightbox_storage_management_url: "https://management.url/v1/acc-12345"
      }
      @service = Fog::Brightbox::Storage.new(@options)
    end

    it "returns a URI matching config option" do
      assert_kind_of URI, @service.management_url
      assert_equal "https://management.url/v1/acc-12345", @service.management_url.to_s
    end
  end

  describe "when unavailable" do
    before do
      @options = {
        brightbox_client_id: "cli-12345",
        brightbox_secret: "1234567890"
      }
      @service = Fog::Brightbox::Storage.new(@options)
    end

    it "returns nil" do
      assert_nil @service.management_url
    end
  end
end
