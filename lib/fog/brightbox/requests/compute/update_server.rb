module Fog
  module Brightbox
    class Compute
      class Real
        # Update some details of the server.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name Editable label
        # @option options [String] :user_data User defined metadata
        # @option options [Array] :server_groups Array of server groups to update server to being a member of. This replaces any existing groups
        # @option options [Boolean] :compatibility_mode Server needs to be shutdown and restarted for changes to this to take effect
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_update_server
        #
        def update_server(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/servers/#{identifier}", [200], options)
        end
      end
    end
  end
end
