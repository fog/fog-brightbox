require "fog/brightbox/models/compute/zone"

module Fog
  module Brightbox
    class Compute
      class Zones < Fog::Collection
        model Fog::Brightbox::Compute::Zone

        def all
          data = service.list_zones
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_zone(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
