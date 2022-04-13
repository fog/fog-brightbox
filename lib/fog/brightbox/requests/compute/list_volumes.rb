module Fog
  module Brightbox
    class Compute
      class Real
        # Lists summary details of volumes available for use by the Account
        #
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        def list_volumes(options = {})
          wrapped_request("get", "/1.0/volumes", [200], options)
        end
      end
    end
  end
end
