module Fog
  module Brightbox
    class Compute
      class DatabaseType < Fog::Brightbox::Model
        identity :id
        attribute :url
        attribute :resource_type

        attribute :name
        attribute :description

        attribute :disk, :aliases => "disk_size"
        attribute :ram
      end
    end
  end
end
