module Fog
  module Brightbox
    class Compute
      class CloudIp < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :status
        attribute :description

        attribute :fqdn
        attribute :mode
        attribute :public_ip
        attribute :public_ipv4
        attribute :public_ipv6
        attribute :reverse_dns

        # Links
        attribute :account_id, aliases: "account", squash: "id"
        attribute :interface_id, aliases: "interface", squash: "id"
        attribute :server_id, aliases: "server", squash: "id"
        attribute :load_balancer, alias: "load_balancer", squash: "id"
        attribute :server_group, alias: "server_group", squash: "id"
        attribute :database_server, alias: "database_server", squash: "id"
        attribute :port_translators

        # Attempt to map or point the Cloud IP to the destination resource.
        #
        # @param [Object] destination
        #
        def map(destination)
          requires :identity
          final_destination = if destination.respond_to?(:mapping_identity)
                                destination.mapping_identity
                              elsif destination.respond_to?(:identity)
                                destination.identity
                              else
                                destination
                              end
          service.map_cloud_ip(identity, destination: final_destination)
        end

        def mapped?
          status == "mapped"
        end

        def unmap
          requires :identity
          service.unmap_cloud_ip(identity)
        end

        def destroy
          requires :identity
          service.delete_cloud_ip(identity)
        end

        def destination_id
          server_id || load_balancer || server_group || database_server || interface_id
        end
      end
    end
  end
end
