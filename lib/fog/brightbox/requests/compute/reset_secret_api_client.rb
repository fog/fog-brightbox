module Fog
  module Brightbox
    class Compute
      class Real
        # Resets the secret used by the API client to a new generated value.
        #
        # The response is the only time the new secret is available in plaintext.
        #
        # Already authenticated tokens will still continue to be valid until expiry.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#api_client_reset_secret_api_client
        #
        def reset_secret_api_client(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/api_clients/#{identifier}/reset_secret", [200], options)
        end
      end
    end
  end
end
