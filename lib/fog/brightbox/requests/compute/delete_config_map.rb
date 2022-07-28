module Fog
  module Brightbox
    class Compute
      class Real
        # Destroy the config map
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        def delete_config_map(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/config_maps/#{identifier}", [200], options)
        end
      end
    end
  end
end
