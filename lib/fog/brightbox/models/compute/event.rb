module Fog
  module Brightbox
    class Compute
      # @api private
      class Event < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :action
        attribute :message
        attribute :short_message

        # Timestamps
        attribute :created_at, type: :time

        # Links
        attribute :affects
        attribute :resource
        attribute :client
        attribute :user
      end
    end
  end
end
