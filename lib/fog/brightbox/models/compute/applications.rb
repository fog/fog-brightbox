require "fog/brightbox/models/compute/application"

module Fog
  module Brightbox
    class Compute
      class Applications < Fog::Collection
        model Fog::Brightbox::Compute::Application

        def all
          data = service.list_applications
          load(data)
        end

        def get(identifier)
          data = service.get_application(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
