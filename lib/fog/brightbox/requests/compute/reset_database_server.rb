module Fog
  module Brightbox
    class Compute
      class Real
        # Reset a database server restarting the DBMS.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        def reset_database_server(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/database_servers/#{identifier}/reset", [202], options)
        end
      end
    end
  end
end
