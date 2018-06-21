require "fog/brightbox/models/compute/database_snapshot"

module Fog
  module Brightbox
    class Compute
      class DatabaseSnapshots < Fog::Collection
        model Fog::Brightbox::Compute::DatabaseSnapshot

        def all
          data = service.list_database_snapshots
          load(data)
        end

        def get(identifier)
          data = service.get_database_snapshot(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
