require "minitest/autorun"
require "fog/brightbox"
require "fog/brightbox/models/storage/directory"
require "fog/brightbox/models/storage/files"

describe Fog::Brightbox::Storage::Files do
  describe "#get_url" do
    before do
      @options = {
        :brightbox_client_id => "cli-12345",
        :brightbox_secret => "1234567890",
        :brightbox_storage_management_url => "https://management.url/v1/acc-12345"
      }
      @service = Fog::Brightbox::Storage.new(@options)
    end

    describe "when directory can generate URL" do
      describe "with object prefixed by forward slash" do
        it do
          assert_equal "https://management.url/v1/acc-12345", @service.management_url.to_s

          directory = Fog::Brightbox::Storage::Directory.new(
            service: @service,
            key: "container-name"
          )
          assert_equal "https://management.url/v1/acc-12345/container-name", directory.public_url

          files = Fog::Brightbox::Storage::Files.new(
            service: @service,
            directory: directory
          )

          expected = "https://management.url/v1/acc-12345/container-name/object"

          assert_equal expected, files.get_url("/object")
        end
      end

      describe "when object is correctly named" do
        it do
          assert_equal "https://management.url/v1/acc-12345", @service.management_url.to_s

          directory = Fog::Brightbox::Storage::Directory.new(
            service: @service,
            key: "container-name"
          )
          assert_equal "https://management.url/v1/acc-12345/container-name", directory.public_url

          files = Fog::Brightbox::Storage::Files.new(
            service: @service,
            directory: directory
          )

          expected = "https://management.url/v1/acc-12345/container-name/object"

          assert_equal expected, files.get_url("object")
        end
      end
    end

    describe "when no management URL" do
      before do
        @options = {
          :brightbox_client_id => "cli-12345",
          :brightbox_secret => "1234567890"
        }
        @service = Fog::Brightbox::Storage.new(@options)
      end

      it do
        assert_equal "", @service.management_url.to_s

        directory = Fog::Brightbox::Storage::Directory.new(
          service: @service,
          key: "container-name"
        )
        assert_equal "/container-name", directory.public_url

        files = Fog::Brightbox::Storage::Files.new(
          service: @service,
          directory: directory
        )

        assert_equal "/container-name/object", files.get_url("/object")
      end
    end
  end
end
