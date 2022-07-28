module Fog
  module Brightbox
    class Compute
      class Zone < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :description
        attribute :handle
        attribute :status
      end
    end
  end
end
