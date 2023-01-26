require "fog/compute/models/server"

module Fog
  module Brightbox
    class Compute
      class Server < Fog::Compute::Server
        include Fog::Brightbox::ModelHelper
        include Fog::Brightbox::Compute::ResourceLocking

        attr_accessor :volume_id
        attr_accessor :volume_size

        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :state, aliases: "status"

        attribute :console_token
        attribute :console_url
        attribute :fqdn
        attribute :hostname
        attribute :user_data

        # Boolean flags
        attribute :compatibility_mode, type: :boolean
        attribute :disk_encrypted, type: :boolean

        # Timestamps
        attribute :created_at, type: :time
        attribute :started_at, type: :time
        attribute :console_token_expires, type: :time
        attribute :deleted_at, type: :time

        # Links
        attribute :account_id, aliases: "account", squash: "id"
        attribute :image_id, aliases: "image", squash: "id"

        attribute :server_type
        attribute :zone
        attribute :cloud_ip # Creation option only

        attribute :cloud_ips
        attribute :interfaces
        attribute :server_groups
        attribute :snapshots
        attribute :volumes

        def initialize(attributes = {})
          # Call super first to initialize the service object for our default image
          super
          self.image_id ||= service.default_image
        end

        def zone_id
          if attributes[:zone_id]
            attributes[:zone_id]
          elsif zone
            zone[:id] || zone["id"]
          end
        end

        def flavor_id
          if attributes[:flavor_id]
            attributes[:flavor_id]
          elsif server_type
            server_type[:id] || server_type["id"]
          end
        end

        def zone_id=(incoming_zone_id)
          attributes[:zone_id] = incoming_zone_id
        end

        def flavor_id=(incoming_flavour_id)
          attributes[:flavor_id] = incoming_flavour_id
        end

        def snapshot(return_snapshot = false)
          requires :identity
          response, snapshot_id = service.snapshot_server(identity, return_link: return_snapshot)

          if return_snapshot
            service.images.get(snapshot_id)
          else
            response
          end
        end

        # Issues a hard reset to the server (or an OS level reboot command)
        #
        # Default behaviour is a hard reboot because it is more reliable
        # because the state of the server's OS is irrelevant.
        #
        # @example Hard reset
        #   @server.reboot
        #
        # @example Soft reset
        #   @server.reboot(false)
        #
        # @param [Boolean] use_hard_reboot
        # @return [Boolean]
        def reboot(use_hard_reboot = true)
          requires :identity
          if ready?
            if use_hard_reboot
              service.reset_server(identity)
            else
              service.reboot_server(identity)
            end
          else
            # Not able to reboot if not ready in the first place
            false
          end
        end

        def start
          requires :identity
          service.start_server(identity)
          true
        end

        def stop
          requires :identity
          service.stop_server(identity)
          true
        end

        def shutdown
          requires :identity
          service.shutdown_server(identity)
          true
        end

        def destroy
          requires :identity
          service.delete_server(identity)
          true
        end

        def flavor
          requires :flavor_id
          service.flavors.get(flavor_id)
        end

        def image
          requires :image_id
          service.images.get(image_id)
        end

        # Returns the public DNS name of the server
        #
        # @return [String]
        #
        def dns_name
          ["public", fqdn].join(".")
        end

        def private_ip_address
          if interfaces.empty?
            nil
          else
            interfaces.first["ipv4_address"]
          end
        end

        def public_ip_address
          if cloud_ips.empty?
            nil
          else
            cloud_ips.first["public_ip"]
          end
        end

        def ready?
          state == "active"
        end

        def activate_console
          requires :identity
          response = service.activate_console_server(identity)
          [response["console_url"], response["console_token"], response["console_token_expires"]]
        end

        def save
          raise Fog::Errors::Error, "Resaving an existing object may create a duplicate" if persisted?
          requires :image_id
          options = {
            name: name,
            zone: zone_id,
            user_data: user_data,
            server_groups: server_groups
          }.delete_if { |_k, v| v.nil? || v == "" }

          options[:server_type] = flavor_id unless flavor_id.nil? || flavor_id == ""
          options[:cloud_ip] = cloud_ip unless cloud_ip.nil? || cloud_ip == ""
          options[:disk_encrypted] = disk_encrypted if disk_encrypted

          if volume_id
            options[:volumes] = [{ volume: volume_id }]
          elsif volume_size
            options[:volumes] = [
              {
                image: image_id,
                size: volume_size
              }
            ]
          else
            options[:image] = image_id
          end

          data = service.create_server(options)
          merge_attributes(data)
          true
        end

        # Replaces the server's identifier with it's interface's identifier for Cloud IP mapping
        #
        # @return [String] the identifier to pass to a Cloud IP mapping request
        def mapping_identity
          interfaces.first["id"]
        end
      end
    end
  end
end
