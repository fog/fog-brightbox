module Fog
  module Brightbox
    class Compute
      class Real
        # Resize a volume, currently limited to expanding volumes.
        #
        # Partitions will need to be expanded within the OS.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        # @option options [Integer] :from The original size (in MiB) to act as a preflight check to prevent duplicate requests
        # @option options [Integer] :to The new size in MiB to change the volume to
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        def resize_volume(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("post", "/1.0/volumes/#{identifier}/resize", [202], options)
        end
      end
    end
  end
end
