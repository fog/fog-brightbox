module Fog
  module Brightbox
    class Compute
      class Real
        # Lists summary details of config maps owned by the account.
        #
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        def list_config_maps(options = {})
          wrapped_request("get", "/1.0/config_maps", [200], options)
        end
      end
    end
  end
end
