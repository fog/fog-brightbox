module Fog
  module Brightbox
    class Compute
      class Real
        # Attach a detached server to a nominated server
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        # @option options [String] :server The identifier of the server
        # @option options [Boolean] :boot Set +true+ to attach as boot volume. Only when server is stopped
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        def attach_volume(identifier, options)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/volumes/#{identifier}/attach", [202], options)
        end
      end
    end
  end
end
