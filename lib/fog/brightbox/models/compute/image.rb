module Fog
  module Brightbox
    class Compute
      class Image < Fog::Brightbox::Model
        include Fog::Brightbox::Compute::ResourceLocking

        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :status
        attribute :description

        attribute :arch
        attribute :disk_size, type: :integer
        attribute :http_url
        attribute :licence_name
        attribute :min_ram, type: :integer
        attribute :server
        attribute :source
        attribute :source_trigger
        attribute :source_type
        attribute :username
        attribute :virtual_size, type: :integer
        attribute :volume

        # Boolean flags
        attribute :compatibility_mode, type: :boolean
        attribute :official, type: :boolean
        attribute :public, type: :boolean

        # Timestamps
        attribute :created_at, type: :time

        # Links
        attribute :ancestor_id, aliases: "ancestor", squash: "id"
        attribute :owner_id, aliases: "owner", squash: "id"

        def ready?
          status == "available"
        end

        def save
          raise Fog::Errors::Error.new("Resaving an existing object may create a duplicate") if persisted?

          options = {
            :arch => arch,
            :description => description,
            :http_url => http_url,
            :name => name,
            :server => server,
            :source => source,
            :username => username,
            :volume => volume
          }.delete_if { |_k, v| v.nil? || v == "" }
          data = service.create_image(options)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          service.delete_image(identity)
          true
        end
      end
    end
  end
end
