module Fog
  module Brightbox
    class Compute
      class Real
        # Get details of the firewall policy
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_policy_get_firewall_policy
        #
        def get_firewall_policy(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/firewall_policies/#{identifier}", [200], options)
        end
      end
    end
  end
end
