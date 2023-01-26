module Fog
  module Brightbox
    class Compute
      class FirewallRule < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :description

        attribute :destination
        attribute :destination_port
        attribute :icmp_type_name
        attribute :protocol
        attribute :source
        attribute :source_port

        # Timestamps
        attribute :created_at, type: :time

        # Links
        attribute :firewall_policy_id, aliases: "firewall_policy", squash: "id"

        # Sticking with existing Fog behaviour, save does not update but creates a new resource
        def save
          raise Fog::Errors::Error, "Resaving an existing object may create a duplicate" if persisted?
          requires :firewall_policy_id
          options = {
            firewall_policy: firewall_policy_id,
            protocol: protocol,
            description: description,
            source: source,
            source_port: source_port,
            destination: destination,
            destination_port: destination_port,
            icmp_type_name: icmp_type_name
          }.delete_if { |_k, v| v.nil? || v == "" }
          data = service.create_firewall_rule(options)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          service.delete_firewall_rule(identity)
          true
        end
      end
    end
  end
end
