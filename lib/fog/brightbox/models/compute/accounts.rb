require "fog/brightbox/models/compute/account"

module Fog
  module Brightbox
    class Compute
      class Accounts < Fog::Collection
        model Fog::Brightbox::Compute::Account

        def all(options = {})
          data = service.list_accounts(options)
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_account(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
