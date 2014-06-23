require "spec_helper"
require "fog/brightbox/models/compute/server"

describe Fog::Compute::Brightbox::Server do
  include ModelSetup

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
end
