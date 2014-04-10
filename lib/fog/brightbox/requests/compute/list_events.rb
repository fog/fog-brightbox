module Fog
  module Compute
    class Brightbox
      class Real
        # Lists events related to the account.
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#event_list_events
        #
        def list_events
          wrapped_request("get", "/1.0/events", [200])
        end

      end
    end
  end
end
