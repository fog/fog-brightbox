module Fog
  module Brightbox
    class Compute
      class ConfigMap < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :data
      end
    end
  end
end
