require "spec_helper"
require "fog/brightbox/models/compute/database_server"

describe Fog::Brightbox::Compute::DatabaseServer do
  include ModelSetup
  include SupportsResourceLocking

  subject { service.database_servers.new }

  describe "when asked for collection name" do
    it "responds 'database_servers'" do
      assert_equal "database_servers", subject.collection_name
    end
  end

  describe "when asked for resource name" do
    it "responds 'database_server'" do
      assert_equal "database_server", subject.resource_name
    end
  end

  describe "when snapshotting with no options" do
    it "returns the database server" do
      stub_request(:post, "http://localhost/1.0/database_servers/dbs-12345/snapshot")
        .with(query: hash_including(:account_id),
              headers: { "Authorization" => "Bearer FAKECACHEDTOKEN" })
        .to_return(status: 202, body: '{"id": "dbs-12345"}', headers: {})

      @database_server = Fog::Brightbox::Compute::DatabaseServer.new(service: service, id: "dbs-12345")
      assert @database_server.snapshot
    end
  end

  describe "when snapshotting with link option" do
    it "returns the new image" do
      link = "<https://api.gb1.brightbox.com/1.0/database_snapshots/dbi-12345>; rel=snapshot"

      stub_request(:post, "http://localhost/1.0/database_servers/dbs-12345/snapshot")
        .with(headers: { "Authorization" => "Bearer FAKECACHEDTOKEN" })
        .to_return(status: 202, body: "{}", headers: { "Link" => link })

      stub_request(:get, "http://localhost/1.0/database_snapshots/dbi-12345")
        .with(query: hash_including(:account_id),
              headers: { "Authorization" => "Bearer FAKECACHEDTOKEN" })
        .to_return(status: 200, body: '{"id": "dbs-12345"}')
      @database_server = Fog::Brightbox::Compute::DatabaseServer.new(service: service, id: "dbs-12345")
      assert_kind_of Fog::Brightbox::Compute::DatabaseSnapshot, @database_server.snapshot(true)
    end
  end

  describe "when building from a snapshot" do
    it "returns the new SQL instance" do
      stub_request(:post, "http://localhost/1.0/database_servers")
        .with(query: hash_including(:account_id),
              headers: { "Authorization" => "Bearer FAKECACHEDTOKEN" },
              body: hash_including(snapshot: "dbi-lv426"))
        .to_return(status: 202, body: '{"id": "dbs-12345"}')

      @database_server = Fog::Brightbox::Compute::DatabaseServer.new(service: service, snapshot_id: "dbi-lv426")
      @database_server.save
      assert_kind_of Fog::Brightbox::Compute::DatabaseServer, @database_server
      assert_equal "dbs-12345", @database_server.id
    end
  end
end
