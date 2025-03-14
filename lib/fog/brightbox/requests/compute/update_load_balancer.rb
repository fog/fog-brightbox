module Fog
  module Brightbox
    class Compute
      class Real
        # Update some details of the load balancer.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name Editable label
        # @option options [Array] :nodes Array of Node parameters
        # @option options [String] :policy Method of Load balancing to use
        # @option options [String] :certificate_pem A X509 SSL certificate in PEM format. Must be included along with 'certificate_key'. If intermediate certificates are required they should be concatenated after the main certificate
        # @option options [String] :certificate_key The RSA private key used to sign the certificate in PEM format. Must be included along with 'certificate_pem'
        # @option options [Boolean] :sslv3 Allow SSL v3 to be used (default: false)
        # @option options [Array] :listeners What port to listen on, port to pass through to and protocol (tcp, http, https, http+ws, https+wss) of listener. Timeout is optional and specified in milliseconds (default is 50000).
        # @option options [String] :healthcheck Healthcheck options - only "port" and "type" required
        # @option options [String] :buffer_size Buffer size in bytes
        # @option options [Array<String>] :domains Array of domain names to assign to the load balancer
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#load_balancer_update_load_balancer
        #
        def update_load_balancer(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/load_balancers/#{identifier}", [202], options)
        end
      end
    end
  end
end
