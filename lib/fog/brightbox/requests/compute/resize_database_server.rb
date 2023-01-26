module Fog
  module Brightbox
    class Compute
      class Real
        # Resize a database server, increasing resources available to the DBMS.
        #
        # A `reset` may be required for the DBMS to pick up changes.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        # @option options [String] :new_type New Database type to use
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        def resize_database_server(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("post", "/1.0/database_servers/#{identifier}/resize", [202], options)
        end
      end
    end
  end
end
