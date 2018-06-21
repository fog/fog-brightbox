module Fog
  module Brightbox
    class Compute
      class Zone < Fog::Brightbox::Model
        identity :id
        attribute :url
        attribute :resource_type

        attribute :status
        attribute :handle

        attribute :description
      end
    end
  end
end
