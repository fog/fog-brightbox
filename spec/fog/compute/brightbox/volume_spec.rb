require "spec_helper"
require "fog/brightbox/models/compute/volume"

describe Fog::Brightbox::Compute::Volume do
  include ModelSetup
  include SupportsResourceLocking

  subject { service.volumes.new }

  describe "when state is 'creating'" do
    it do
      subject.state = "creating"

      assert subject.creating?
      refute subject.attached?
      refute subject.detached?
      refute subject.deleting?
      refute subject.deleted?
      refute subject.failed?

      refute subject.ready?
      refute subject.finished?
    end
  end

  describe "when state is 'attached'" do
    it do
      subject.state = "attached"

      refute subject.creating?
      assert subject.attached?
      refute subject.detached?
      refute subject.deleting?
      refute subject.deleted?
      refute subject.failed?

      assert subject.ready?
      refute subject.finished?
    end
  end

  describe "when state is 'detached'" do
    it do
      subject.state = "detached"

      refute subject.creating?
      refute subject.attached?
      assert subject.detached?
      refute subject.deleting?
      refute subject.deleted?
      refute subject.failed?

      assert subject.ready?
      refute subject.finished?
    end
  end

  describe "when state is 'deleting'" do
    it do
      subject.state = "deleting"

      refute subject.creating?
      refute subject.attached?
      refute subject.detached?
      assert subject.deleting?
      refute subject.deleted?
      refute subject.failed?

      refute subject.ready?
      refute subject.finished?
    end
  end

  describe "when state is 'deleted'" do
    it do
      subject.state = "deleted"

      refute subject.creating?
      refute subject.attached?
      refute subject.detached?
      refute subject.deleting?
      assert subject.deleted?
      refute subject.failed?

      refute subject.ready?
      assert subject.finished?
    end
  end

  describe "when state is 'failed'" do
    it do
      subject.state = "failed"

      refute subject.creating?
      refute subject.attached?
      refute subject.detached?
      refute subject.deleting?
      refute subject.deleted?
      assert subject.failed?

      refute subject.ready?
      assert subject.finished?
    end
  end

  describe "#attach" do
    it do
      subject.id = "vol-12345"
      assert subject.persisted?

      server = service.servers.new
      server.id = "srv-12345"

      stub_request(:post, "http://localhost/1.0/volumes/vol-12345/attach")
        .with(query: hash_including(:account_id),
              headers: { "Authorization" => "Bearer FAKECACHEDTOKEN",
                         "Content-Type" => "application/json" },
              body: hash_including(server: "srv-12345"))
        .to_return(status: 202,
                   body: '{"id":"vol-12345","status":"attached"}',
                   headers: {})

      subject.attach(server)

      assert subject.attached?
    end
  end

  describe "#collection_name" do
    it "responds 'volumes'" do
      assert_equal "volumes", subject.collection_name
    end
  end

  describe "#copy" do
    it do
      subject.id = "vol-12345"
      subject.state = "attached"
      subject.delete_with_server = false

      refute subject.delete_with_server
      assert subject.persisted?

      stub_request(:post, "http://localhost/1.0/volumes/vol-12345/copy")
        .with(query: hash_including(:account_id),
              headers: { "Authorization" => "Bearer FAKECACHEDTOKEN",
                         "Content-Type" => "application/json" },
              body: hash_including(delete_with_server: true))
        .to_return(status: 202,
                   body: '{"id":"vol-abcde","delete_with_server":true,"name":"Copy of vol-12345 (Impish Image)","status":"detached"}',
                   headers: {})

      copy = subject.copy(delete_with_server: true)

      assert copy.persisted?
      assert_equal "vol-abcde", copy.id
      assert copy.delete_with_server
      assert copy.detached?
    end
  end

  describe "#detach" do
    it do
      subject.id = "vol-12345"
      subject.state = "attached"

      assert subject.persisted?

      stub_request(:post, "http://localhost/1.0/volumes/vol-12345/detach")
        .with(query: hash_including(:account_id),
              headers: { "Authorization" => "Bearer FAKECACHEDTOKEN",
                         "Content-Type" => "application/json" })
        .to_return(status: 202,
                   body: '{"id":"vol-12345","status":"detached"}',
                   headers: {})

      subject.detach

      assert subject.detached?
    end
  end

  describe "#destroy" do
    it do
      subject.id = "vol-12345"
      assert subject.persisted?

      stub_request(:delete, "http://localhost/1.0/volumes/vol-12345")
        .with(query: hash_including(:account_id),
              headers: { "Authorization" => "Bearer FAKECACHEDTOKEN",
                         "Content-Type" => "application/json" })
        .to_return(status: 202,
                   body: '{"id":"vol-12345","status":"deleting"}',
                   headers: {})

      subject.destroy
      assert_equal "deleting", subject.state
    end
  end

  describe "#ready?" do
    describe "when state is 'creating'" do
      it do
        subject.state = "creating"

        refute subject.ready?
      end
    end

    describe "when state is 'attached'" do
      it do
        subject.state = "attached"

        assert subject.ready?
      end
    end

    describe "when state is 'detached'" do
      it do
        subject.state = "detached"

        assert subject.ready?
      end
    end
  end

  describe "#resize" do
    it do
      subject.id = "vol-12345"
      subject.size = 40_000

      assert subject.persisted?

      stub_request(:post, "http://localhost/1.0/volumes/vol-12345/resize")
        .with(query: hash_including(:account_id),
              headers: { "Authorization" => "Bearer FAKECACHEDTOKEN",
                         "Content-Type" => "application/json" },
              body: hash_including(from: 40_000, to: 50_000))
        .to_return(status: 202,
                   body: '{"id":"vol-12345","size": 50000}',
                   headers: {})

      subject.resize(to: 50_000)

      assert 50_000, subject.size
    end
  end

  describe "#resource_name" do
    it "responds 'volume'" do
      assert_equal "volume", subject.resource_name
    end
  end

  describe "#save" do
    describe "when creating" do
      describe "with mutually exclusive arguments" do
        it "raises Fog::Errors::Error" do
          options = {
            filesystem_type: "ext4",
            image_id: "img-12345"
          }

          @volume = Fog::Brightbox::Compute::Volume.new({ service: service }.merge(options))

          assert_raises Fog::Errors::Error do
            @volume.save
          end
        end
      end

      describe "with filesytem type" do
        it "sends correct JSON" do
          options = {
            description: "An ext4 volume",
            filesystem_type: "ext4"
          }

          stub_request(:post, "http://localhost/1.0/volumes")
            .with(query: hash_including(:account_id),
                  headers: { "Authorization" => "Bearer FAKECACHEDTOKEN",
                             "Content-Type" => "application/json" },
                  body: hash_including(filesystem_type: "ext4"))
            .to_return(status: 202,
                       body: '{"id":"vol-12345","image":{"id":"img-blank"}}',
                       headers: {})

          @volume = Fog::Brightbox::Compute::Volume.new({ service: service }.merge(options))
          assert @volume.save
          assert_equal @volume.filesystem_type, "ext4"
          assert_equal @volume.image_id, "img-blank"
          assert_equal @volume.description, "An ext4 volume"
        end
      end

      describe "with image" do
        it "sends correct JSON" do
          options = {
            image_id: "img-12345",
            name: "My Volume"
          }

          stub_request(:post, "http://localhost/1.0/volumes")
            .with(query: hash_including(:account_id),
                  headers: { "Authorization" => "Bearer FAKECACHEDTOKEN",
                             "Content-Type" => "application/json" },
                  body: hash_including(image: "img-12345"))
            .to_return(status: 202,
                       body: '{"id":"vol-12345","image":{"id":"img-12345"}}',
                       headers: {})

          @volume = Fog::Brightbox::Compute::Volume.new({ service: service }.merge(options))
          assert @volume.save
          assert_equal @volume.image_id, "img-12345"
          assert_equal @volume.name, "My Volume"
        end
      end
    end

    describe "when updating" do
      it do
        subject.id = "vol-12345"

        assert subject.persisted?

        subject.delete_with_server = true
        subject.description = "Updated description"
        subject.name = "New name"
        subject.serial = "NewSerial"

        stub_request(:put, "http://localhost/1.0/volumes/vol-12345")
          .with(query: hash_including(:account_id),
                headers: { "Authorization" => "Bearer FAKECACHEDTOKEN",
                           "Content-Type" => "application/json" },
                body: hash_including(delete_with_server: true,
                                     description: "Updated description",
                                     name: "New name",
                                     serial: "NewSerial"))
          .to_return(status: 202,
                     body: '{"id":"vol-12345"}',
                     headers: {})

        subject.save
      end
    end
  end
end
