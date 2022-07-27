module Fog
  module Brightbox
    class Compute
      class Real
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        def get_config_map(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/config_maps/#{identifier}", [200], options)
        end
      end
    end
  end
end
