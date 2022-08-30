require "spec_helper"
require "fog/brightbox/models/compute/server"

describe Fog::Brightbox::Compute::Server do
  include ModelSetup
  include SupportsResourceLocking

  subject { service.servers.new }

  describe "when asked for collection name" do
    it "responds 'servers'" do
      assert_equal "servers", subject.collection_name
    end
  end

  describe "when asked for resource name" do
    it "responds 'server'" do
      assert_equal "server", subject.resource_name
    end
  end

  describe "when creating" do
    describe "with image_id" do
      it "sends correct JSON" do
        options = {
          image_id: "img-12345"
        }

        stub_request(:post, "http://localhost/1.0/servers").
          with(:query => hash_including(:account_id),
               :headers => { "Authorization" => "Bearer FAKECACHEDTOKEN",
                             "Content-Type" => "application/json" },
                             :body => hash_including(:image => "img-12345")).
        to_return(:status => 202, :body => %q({"id":"srv-12345"}), :headers => {})

        @server = Fog::Brightbox::Compute::Server.new({ :service => service }.merge(options))
        assert @server.save
      end
    end

    describe "with image_id and custom size" do
      it "sends correct JSON" do
        options = {
          image_id: "img-12345",
          volume_size: 25_000
        }
        expected_args = {
          volumes: [
            {
              image: "img-12345",
              size: 25_000
            }
          ]
        }

        stub_request(:post, "http://localhost/1.0/servers").
          with(:query => hash_including(:account_id),
               :headers => { "Authorization" => "Bearer FAKECACHEDTOKEN",
                             "Content-Type" => "application/json" },
                             :body => hash_including(expected_args)).
        to_return(:status => 202, :body => %q({"id":"srv-12345"}), :headers => {})

        @server = Fog::Brightbox::Compute::Server.new({ :service => service }.merge(options))
        assert @server.save
      end
    end

    describe "with additional disk_encrypted" do
      it "sends correct JSON" do
        options = {
          image_id: "img-12345",
          disk_encrypted: true
        }

        stub_request(:post, "http://localhost/1.0/servers").
          with(:query => hash_including(:account_id),
               :headers => { "Authorization" => "Bearer FAKECACHEDTOKEN",
                             "Content-Type" => "application/json" },
                             :body => hash_including(:disk_encrypted => true)).
          to_return(:status => 202,
                    :body => %q({"id":"srv-12345","disk_encrypted":true}),
                    :headers => {})

        @server = Fog::Brightbox::Compute::Server.new({ :service => service }.merge(options))
        assert @server.save
        assert @server.disk_encrypted
      end
    end
  end

  describe "with volume_id" do
    it "sends correct JSON" do
      options = {
        volume_id: "vol-12345"
      }
      expected_args = {
        volumes: [{ volume: "vol-12345" }]
      }

      stub_request(:post, "http://localhost/1.0/servers").
        with(:query => hash_including(:account_id),
             :headers => { "Authorization" => "Bearer FAKECACHEDTOKEN",
                           "Content-Type" => "application/json" },
                           :body => hash_including(expected_args)).
      to_return(:status => 202, :body => %q({"id":"srv-12345"}), :headers => {})

      @server = Fog::Brightbox::Compute::Server.new({ :service => service }.merge(options))
      assert @server.save
    end
  end

  describe "when snapshotting with no options" do
    it "returns the server" do
      stub_request(:post, "http://localhost/1.0/servers/srv-12345/snapshot").
        with(:query => hash_including(:account_id),
             :headers => { "Authorization" => "Bearer FAKECACHEDTOKEN" }).
        to_return(:status => 202, :body => %q({"id": "srv-12345"}), :headers => {})

      @server = Fog::Brightbox::Compute::Server.new(:service => service, :id => "srv-12345")
      assert_kind_of Hash, @server.snapshot
    end
  end

  describe "when snapshotting with link option" do
    it "returns the new image" do
      link = "<https://api.gb1.brightbox.com/1.0/images/img-12345>; rel=snapshot"

      stub_request(:post, "http://localhost/1.0/servers/srv-12345/snapshot").
        with(:headers => { "Authorization" => "Bearer FAKECACHEDTOKEN" }).
        to_return(:status => 202, :body => "{}", :headers => { "Link" => link })

      stub_request(:get, "http://localhost/1.0/images/img-12345").
        with(:query => hash_including(:account_id),
             :headers => { "Authorization" => "Bearer FAKECACHEDTOKEN" }).
        to_return(:status => 200, :body => %q({"id": "img-12345"}))
      @server = Fog::Brightbox::Compute::Server.new(:service => service, :id => "srv-12345")
      assert_kind_of Fog::Brightbox::Compute::Image, @server.snapshot(true)
    end
  end
end
