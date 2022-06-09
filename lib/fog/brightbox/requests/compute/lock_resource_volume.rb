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
        def lock_resource_volume(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          wrapped_request("put", "/1.0/volumes/#{identifier}/lock_resource", [200], options)
        end
      end
    end
  end
end
