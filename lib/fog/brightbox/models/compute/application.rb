module Fog
  module Brightbox
    class Compute
      class Application < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :description
        attribute :secret

        # Timestamps
        attribute :created_at, type: :time
        attribute :updated_at, type: :time
        attribute :revoked_at, type: :time

        def save
          raise Fog::Errors::Error, "Resaving an existing object may create a duplicate" if persisted?
          options = {
            name: name
          }.delete_if { |_k, v| v.nil? || v == "" }
          data = service.create_application(options)
          merge_attributes(data)
          true
        end
      end
    end
  end
end
