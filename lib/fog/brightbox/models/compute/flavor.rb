module Fog
  module Brightbox
    class Compute
      class Flavor < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :status
        attribute :description

        attribute :handle

        attribute :bits
        attribute :cores
        attribute :disk, aliases: "disk_size"
        attribute :ram

        def bits
          64 # This is actually based on the Image type used. 32bit or 64bit Images are supported
        end
      end
    end
  end
end
