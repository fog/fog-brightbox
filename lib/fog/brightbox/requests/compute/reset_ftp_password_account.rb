module Fog
  module Compute
    class Brightbox
      class Real
        # Reset the image library ftp password for the account.
        #
        # @note The response is the only time the new password is available in plaintext.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#account_reset_ftp_password_account
        #
        def reset_ftp_password_account(identifier = nil, options = {})
          wrapped_request("post", "/1.0/accounts/#{identifier}/reset_ftp_password", [200], options)
        end
      end
    end
  end
end
