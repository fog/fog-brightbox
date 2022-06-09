require "fog/brightbox/models/compute/volume"

module Fog
  module Brightbox
    class Compute
      class Volumes < Fog::Collection
        model Fog::Brightbox::Compute::Volume

        def all
          data = service.list_volumes
          load(data)
        end

        def get(identifier)
          data = service.get_volume(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
