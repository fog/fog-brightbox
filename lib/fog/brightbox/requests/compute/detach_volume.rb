module Fog
  module Brightbox
    class Compute
      class Real
        # Detach the volume from its server
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        def detach_volume(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/volumes/#{identifier}/detach", [202], options)
        end
      end
    end
  end
end
