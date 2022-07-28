module Fog
  module Brightbox
    class Compute
      class DatabaseType < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :description

        attribute :disk, aliases: "disk_size"
        attribute :ram
      end
    end
  end
end
