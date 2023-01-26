module Fog
  module Brightbox
    class Compute
      class User < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :email_address
        attribute :ssh_key

        # Boolean flags
        attribute :email_verified, type: :boolean

        # Timestamps
        attribute :created_at, type: :time

        # Links
        attribute :account_id, aliases: "default_account", squash: "id"
        attribute :accounts

        # Deprecated
        attribute :messaging_pref, type: :boolean

        def save
          requires :identity

          options = {
            email_address: email_address,
            ssh_key: ssh_key,
            name: name
          }

          data = service.update_user(identity, options)
          merge_attributes(data)
          true
        end
      end
    end
  end
end
