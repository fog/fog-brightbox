module Fog
  module Brightbox
    class Compute
      class Account < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :status

        attribute :address_1
        attribute :address_2
        attribute :city
        attribute :county
        attribute :postcode
        attribute :country_code
        attribute :country_name
        attribute :vat_registration_number
        attribute :telephone_number
        attribute :verified_telephone
        attribute :verified_ip

        # Account limits (read-only)
        attribute :block_storage_limit, type: :integer
        attribute :block_storage_used, type: :integer
        attribute :cloud_ips_limit, type: :integer
        attribute :cloud_ips_used, type: :integer
        attribute :dbs_instances_used, type: :integer
        attribute :dbs_ram_limit, type: :integer
        attribute :dbs_ram_used, type: :integer
        attribute :load_balancers_limit, type: :integer
        attribute :load_balancers_used, type: :integer
        attribute :ram_limit, type: :integer
        attribute :ram_used, type: :integer
        attribute :servers_used, type: :integer

        attribute :library_ftp_host
        attribute :library_ftp_user
        # This is always returned as nil unless after a call to reset_ftp_password
        attribute :library_ftp_password

        # Boolean flags
        attribute :valid_credit_card, type: :boolean
        attribute :telephone_verified, type: :boolean

        # Timestamps
        attribute :created_at, type: :time
        attribute :verified_at, type: :time

        # Links
        attribute :owner_id, aliases: "owner", squash: "id"
        attribute :clients
        attribute :cloud_ips
        attribute :database_servers
        attribute :database_snapshots
        attribute :firewall_policies
        attribute :images
        attribute :load_balancers
        attribute :server_groups
        attribute :servers
        attribute :users
        attribute :volumes
        attribute :zones

        # Resets the account's image library FTP password returning the new value
        #
        # @return [String] Newly issue FTP password
        #
        def reset_ftp_password
          requires :identity
          data = service.reset_ftp_password_account(identity)
          merge_attributes(data)
          library_ftp_password
        end
      end
    end
  end
end
