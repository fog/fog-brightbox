module Fog
  module Brightbox
    class Storage
      class Real
        # Get details for object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        #
        def get_object(container, object, &block)
          params = {
            expects: 200,
            method: "GET",
            path: "#{Fog::Brightbox::Storage.escape(container)}/#{Fog::Brightbox::Storage.escape(object)}"
          }

          params[:response_block] = block if block_given?

          request(params, false)
        end
      end
    end
  end
end
