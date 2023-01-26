require "minitest/autorun"
require "fog/brightbox"
require "fog/brightbox/models/storage/directory"

describe Fog::Brightbox::Storage::Directory do
  include StockStorageResponses

  let(:config) { Fog::Brightbox::Config.new(settings) }
  let(:service) { Fog::Brightbox::Storage.new(config) }

  describe ".create" do
    let(:settings) do
      {
        brightbox_client_id: "cli-12345",
        brightbox_secret: "fdkls"
      }
    end
    let(:read_permissions) { ".r:*" }
    let(:write_permissions) { "*:*" }

    before do
      stub_request(:get, "https://orbit.brightbox.com/v1").
        to_return(authorized_response)

      stub_request(:put, "https://orbit.brightbox.com/v1/acc-12345/container-name").
        to_return(status: 201)
    end

    it do
      directory = service.directories.create(
        service: service,
        key: "container-name",
        read_permissions: read_permissions,
        write_permissions: write_permissions
      )

      assert directory.read_permissions, read_permissions
      assert directory.write_permissions, write_permissions

      assert_requested(
        :put,
        "https://orbit.brightbox.com/v1/acc-12345/container-name",
        headers: {
          "X-Container-Read" => read_permissions,
          "X-Container-Write" => write_permissions
        }
      )
    end
  end
end
