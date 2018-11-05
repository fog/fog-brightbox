require "fog/brightbox/models/compute/event"

module Fog
  module Brightbox
    class Compute
      class Events < Fog::Collection
        model Fog::Brightbox::Compute::Event

        def all
          data = service.list_events
          load(data)
        end
      end
    end
  end
end
