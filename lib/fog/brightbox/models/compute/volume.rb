module Fog
  module Brightbox
    class Compute
      class Volume < Fog::Brightbox::Model
        include Fog::Brightbox::Compute::ResourceLocking

        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :state, aliases: "status"
        attribute :description

        attribute :filesystem_label
        attribute :filesystem_type
        attribute :serial
        attribute :size, type: :integer
        attribute :source
        attribute :source_type
        attribute :storage_type

        # Boolean flags
        attribute :boot, type: :boolean
        attribute :delete_with_server, type: :boolean
        attribute :encrypted, type: :boolean

        # Timestamps
        attribute :created_at, type: :time
        attribute :updated_at, type: :time
        attribute :deleted_at, type: :time

        # Links
        attribute :account_id, aliases: "account", squash: "id"
        attribute :image_id, aliases: "image", squash: "id"
        attribute :server_id, aliases: "server", squash: "id"

        def attach(server)
          requires :identity
          data = service.attach_volume(identity, server: server.id)
          merge_attributes(data)
          true
        end

        def attached?
          state == "attached"
        end

        # @param [Hash] options
        # @option options [Boolean] :delete_with_server Set +true+ the volume will be removed if attached to a server that is deleted
        # @option options [String] :description
        # @option options [String] :name
        # @option options [String] :serial
        #
        # @return [Fog::Compute::Volume] a new model for the copy
        def copy(options = {})
          requires :identity
          data = service.copy_volume(identity, options)
          service.volumes.new(data)
        end

        def creating?
          state == "creating"
        end

        def deleted?
          state == "deleted"
        end

        def deleting?
          state == "deleting"
        end

        def detach
          requires :identity
          data = service.detach_volume(identity)
          merge_attributes(data)
          true
        end

        def detached?
          state == "detached"
        end

        def failed?
          state == "failed"
        end

        def finished?
          deleted? || failed?
        end

        def ready?
          attached? || detached?
        end

        # @param [Hash] options
        # @option options [Integer] :to The new size in MiB to change the volume to
        def resize(options)
          requires :identity

          # The API requires the old "from" size to avoid acting on stale data
          # We can merge this and if the API rejects the request, the model was out of sync
          options.merge!(:from => size)

          data = service.resize_volume(identity, options)
          merge_attributes(data)
          true
        end

        def save
          if persisted?
            options = {
              :delete_with_server => delete_with_server,
              :description => description,
              :name => name,
              :serial => serial
            }.delete_if { |_k, v| v.nil? || v == "" }

            data = service.update_volume(identity, options)
          else
            raise Fog::Errors::Error.new("'image_id' and 'filesystem_type' are mutually exclusive") if image_id && filesystem_type
            raise Fog::Errors::Error.new("'image_id' or 'filesystem_type' is required") unless image_id || filesystem_type

            options = {
              :delete_with_server => delete_with_server,
              :description => description,
              :filesystem_label => filesystem_label,
              :filesystem_type => filesystem_type,
              :name => name,
              :serial => serial,
              :size => size
            }.delete_if { |_k, v| v.nil? || v == "" }

            options.merge!(:image => image_id) unless image_id.nil? || image_id == ""

            data = service.create_volume(options)
          end

          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          data = service.delete_volume(identity)
          merge_attributes(data)
          true
        end
      end
    end
  end
end
