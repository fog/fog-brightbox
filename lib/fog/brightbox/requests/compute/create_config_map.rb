module Fog
  module Brightbox
    class Compute
      class Real
        # Create a new config map
        #
        # @param [Hash] options
        # @option options [String] :name to identify this config map
        # @option options [Hash] :data key/values to expose in config map
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        def create_config_map(options)
          return nil if options.empty? || options.nil?
          wrapped_request("post", "/1.0/config_maps", [200], options)
        end
      end
    end
  end
end
