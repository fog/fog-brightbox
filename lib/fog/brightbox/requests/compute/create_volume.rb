module Fog
  module Brightbox
    class Compute
      class Real
        # Create a new volume
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        # @option options [Boolean] :delete_with_server Set +true+ the volume will be removed if attached to a server that is deleted
        # @option options [String] :description
        # @option options [String] :name
        # @option options [String] :serial
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        def create_volume(options)
          return nil if options.empty? || options.nil?
          wrapped_request("post", "/1.0/volumes", [202], options)
        end
      end
    end
  end
end
