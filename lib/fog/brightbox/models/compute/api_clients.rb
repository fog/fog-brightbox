require "fog/brightbox/models/compute/api_client"

module Fog
  module Brightbox
    class Compute
      class ApiClients < Fog::Collection
        model Fog::Brightbox::Compute::ApiClient

        def all
          data = service.list_api_clients
          load(data)
        end

        def get(identifier = nil)
          data = service.get_api_client(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
