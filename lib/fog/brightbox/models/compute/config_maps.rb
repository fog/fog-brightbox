module Fog
  module Brightbox
    class Compute
      class ConfigMaps < Fog::Collection
        model Fog::Brightbox::Compute::ConfigMap

        def all
          data = service.list_config_maps
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_config_map(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
