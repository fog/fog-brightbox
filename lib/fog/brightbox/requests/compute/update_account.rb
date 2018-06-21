module Fog
  module Brightbox
    class Compute
      class Real
        # Update some details of the account.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name Account name
        # @option options [String] :address_1 First line of address
        # @option options [String] :address_2 Second line of address
        # @option options [String] :city City part of address
        # @option options [String] :county County part of address
        # @option options [String] :postcode Postcode or Zipcode
        # @option options [String] :country_code ISO 3166-1 two letter code (example: `GB`)
        # @option options [String] :vat_registration_number Must be a valid EU VAT number or `nil`
        # @option options [String] :telephone_number Valid International telephone number in E.164 format prefixed with `+`
        # @option options [Boolean] :nested passed through with the API request. When true nested resources are expanded.
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#account_update_account
        #
        def update_account(*args)
          if args.size == 2
            identifier = args[0]
            options = args[1]
          elsif args.size == 1
            options = args[0]
          else
            raise ArgumentError, "wrong number of arguments (0 for 2)"
          end

          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/accounts/#{identifier}", [200], options)
        end
      end
    end
  end
end
