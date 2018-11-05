require "fog/brightbox/models/compute/database_type"

module Fog
  module Brightbox
    class Compute
      class DatabaseTypes < Fog::Collection
        model Fog::Brightbox::Compute::DatabaseType

        def all
          data = service.list_database_types
          load(data)
        end

        def get(identifier)
          data = service.get_database_type(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
