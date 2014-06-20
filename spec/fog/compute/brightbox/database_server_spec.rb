require "spec_helper"
require "fog/brightbox/models/compute/database_server"

describe Fog::Compute::Brightbox::DatabaseServer do
  include ModelSetup

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
end
