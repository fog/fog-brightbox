module Fog
  module Brightbox
    class Compute
      class Real
        # Destroy the volume and free up the resources.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        def delete_volume(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/volumes/#{identifier}", [202], options)
        end
      end
    end
  end
end
