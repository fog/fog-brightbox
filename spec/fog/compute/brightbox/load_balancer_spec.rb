require "spec_helper"
require "fog/brightbox/models/compute/load_balancer"

describe Fog::Brightbox::Compute::LoadBalancer do
  include ModelSetup
  include SupportsResourceLocking

  subject { service.load_balancers.new }

  describe "when asked for collection name" do
    it "responds 'load_balancers'" do
      assert_equal "load_balancers", subject.collection_name
    end
  end

  describe "when asked for resource name" do
    it "responds 'load_balancer'" do
      assert_equal "load_balancer", subject.resource_name
    end
  end

  describe "when creating" do
    it "send correct JSON" do
      options = {
        healthcheck: {},
        listeners: [
          {
            protocol: "http",
            in: 80,
            out: 80
          }
        ],
        nodes: []
      }

      stub_request(:post, "http://localhost/1.0/load_balancers")
        .with(query: hash_including(:account_id),
              headers: { "Authorization" => "Bearer FAKECACHEDTOKEN" })
        .to_return(status: 202, body: '{"id": "lba-12345"}', headers: {})

      @load_balancer = Fog::Brightbox::Compute::LoadBalancer.new({ service: service }.merge(options))
      assert @load_balancer.save
    end
  end
end
