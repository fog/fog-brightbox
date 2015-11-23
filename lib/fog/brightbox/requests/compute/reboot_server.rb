module Fog
  module Compute
    class Brightbox
      class Real
        # Issues a 'soft' reboot to the server however the OS may ignore it. The console remains connected.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_reboot_server
        #
        def reboot_server(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/servers/#{identifier}/reboot", [202])
        end
      end
    end
  end
end
