require "fog/brightbox/models/compute/firewall_rule"

module Fog
  module Brightbox
    class Compute
      class FirewallRules < Fog::Collection
        model Fog::Brightbox::Compute::FirewallRule

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_firewall_rule(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
