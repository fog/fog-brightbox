module Fog
  module Brightbox
    class Compute
      class Image < Fog::Brightbox::Model
        include Fog::Brightbox::Compute::ResourceLocking

        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :username
        attribute :status
        attribute :description

        attribute :source
        attribute :source_type
        attribute :arch
        attribute :virtual_size
        attribute :disk_size
        attribute :licence_name

        # Boolean flags
        attribute :public
        attribute :official
        attribute :compatibility_mode

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
          requires :source, :arch
          options = {
            :source => source,
            :arch => arch,
            :name => name,
            :username => username,
            :description => description
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
