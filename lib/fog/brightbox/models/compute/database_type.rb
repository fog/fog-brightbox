module Fog
  module Brightbox
    class Compute
      class DatabaseType < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :description

        attribute :disk, aliases: "disk_size", type: :integer
        attribute :ram, type: :integer

        # Boolean flags
        attribute :default, type: :boolean
      end
    end
  end
end
