module Fog
  module Brightbox
    class Compute < Fog::Service
      autoload :Config, File.expand_path("../compute/config", __FILE__)
      autoload :ImageSelector, File.expand_path("../compute/image_selector", __FILE__)
      autoload :ResourceLocking, File.expand_path("../compute/resource_locking", __FILE__)
      autoload :Shared, File.expand_path("../compute/shared", __FILE__)

      # Client credentials
      requires :brightbox_client_id, :brightbox_secret

      # API endpoint settings
      recognizes :brightbox_auth_url, :brightbox_api_url

      # User credentials (still requires client details)
      recognizes :brightbox_username, :brightbox_password, :brightbox_account

      # Cached tokens
      recognizes :brightbox_access_token, :brightbox_refresh_token

      # Automatic token management
      recognizes :brightbox_token_management

      # Two Factor Authentication support (2FA)
      recognizes :brightbox_support_two_factor
      recognizes :brightbox_one_time_password

      # Excon connection settings
      recognizes :persistent

      model_path "fog/brightbox/models/compute"
      collection :accounts
      model :account
      collection :applications
      model :application
      collection :api_clients
      model :api_client
      collection :collaborations
      model :collaboration
      collection :config_maps
      model :config_map
      collection :servers
      model :server
      collection :server_groups
      model :server_group
      collection :events
      model :event
      collection :firewall_policies
      model :firewall_policy
      collection :firewall_rules
      model :firewall_rule
      collection :flavors
      model :flavor
      collection :images
      model :image
      collection :load_balancers
      model :load_balancer
      collection :database_servers
      model :database_server
      collection :database_snapshots
      model :database_snapshot
      collection :database_types
      model :database_type
      collection :zones
      model :zone
      collection :cloud_ips
      model :cloud_ip
      collection :users
      model :user
      collection :user_collaborations
      model :user_collaboration
      collection :volumes
      model :volume

      request_path "fog/brightbox/requests/compute"
      request :accept_user_collaboration
      request :activate_console_server
      request :add_listeners_load_balancer
      request :add_nodes_load_balancer
      request :add_servers_server_group
      request :apply_to_firewall_policy
      request :attach_volume
      request :copy_volume
      request :create_api_client
      request :create_application
      request :create_cloud_ip
      request :create_collaboration
      request :create_config_map
      request :create_database_server
      request :create_firewall_policy
      request :create_firewall_rule
      request :create_image
      request :create_load_balancer
      request :create_server
      request :create_server_group
      request :create_volume
      request :delete_api_client
      request :delete_application
      request :delete_cloud_ip
      request :delete_collaboration
      request :delete_config_map
      request :delete_database_server
      request :delete_database_snapshot
      request :delete_firewall_policy
      request :delete_firewall_rule
      request :delete_image
      request :delete_load_balancer
      request :delete_server
      request :delete_server_group
      request :delete_user_collaboration
      request :delete_volume
      request :detach_volume
      request :get_account
      request :get_api_client
      request :get_application
      request :get_authenticated_user
      request :get_cloud_ip
      request :get_collaboration
      request :get_config_map
      request :get_database_server
      request :get_database_snapshot
      request :get_database_type
      request :get_firewall_policy
      request :get_firewall_rule
      request :get_image
      request :get_interface
      request :get_load_balancer
      request :get_scoped_account
      request :get_server
      request :get_server_group
      request :get_server_type
      request :get_user
      request :get_user_collaboration
      request :get_volume
      request :get_zone
      request :list_accounts
      request :list_api_clients
      request :list_applications
      request :list_cloud_ips
      request :list_collaborations
      request :list_config_maps
      request :list_database_servers
      request :list_database_snapshots
      request :list_database_types
      request :list_events
      request :list_firewall_policies
      request :list_images
      request :list_load_balancers
      request :list_server_groups
      request :list_server_types
      request :list_servers
      request :list_user_collaborations
      request :list_users
      request :list_volumes
      request :list_zones
      request :lock_resource_database_server
      request :lock_resource_database_snapshot
      request :lock_resource_image
      request :lock_resource_load_balancer
      request :lock_resource_server
      request :lock_resource_volume
      request :map_cloud_ip
      request :move_servers_server_group
      request :reboot_server
      request :reject_user_collaboration
      request :remove_firewall_policy
      request :remove_listeners_load_balancer
      request :remove_nodes_load_balancer
      request :remove_servers_server_group
      request :resend_collaboration
      request :reset_ftp_password_account
      request :reset_ftp_password_scoped_account
      request :reset_password_database_server
      request :reset_secret_api_client
      request :reset_secret_application
      request :reset_server
      request :resize_volume
      request :shutdown_server
      request :snapshot_database_server
      request :snapshot_server
      request :start_server
      request :stop_server
      request :unlock_resource_database_server
      request :unlock_resource_database_snapshot
      request :unlock_resource_image
      request :unlock_resource_load_balancer
      request :unlock_resource_server
      request :unlock_resource_volume
      request :unmap_cloud_ip
      request :update_account
      request :update_api_client
      request :update_application
      request :update_cloud_ip
      request :update_config_map
      request :update_database_server
      request :update_database_snapshot
      request :update_firewall_policy
      request :update_firewall_rule
      request :update_image
      request :update_load_balancer
      request :update_scoped_account
      request :update_server
      request :update_server_group
      request :update_user
      request :update_volume

      # The Mock Service allows you to run a fake instance of the Service
      # which makes no real connections.
      #
      # @todo Implement
      #
      class Mock
        include Fog::Brightbox::Compute::Shared

        def request(_method, _path, _expected_responses, _parameters = {})
          _request
        end

        def request_access_token(_connection, _credentials)
          _request
        end

        private

        def _request
          raise Fog::Errors::MockNotImplemented
        end

        def select_default_image
          "img-mockd"
        end
      end

      # The Real Service actually makes real connections to the Brightbox
      # service.
      #
      class Real
        include Fog::Brightbox::Compute::Shared

        # Makes an API request to the given path using passed options or those
        # set with the service setup
        #
        # @param [Hash] params Excon compatible options
        # @option params [String] :body text to be sent over a socket
        # @option params [Hash<Symbol, String>] :headers The default headers to supply in a request
        # @option params [String] :host The destination host's reachable DNS name or IP, in the form of a String
        # @option params [String] :path appears after 'scheme://host:port/'
        # @option params [Fixnum] :port The port on which to connect, to the destination host
        # @option params [Hash]   :query appended to the 'scheme://host:port/path/' in the form of '?key=value'
        # @option params [String] :scheme The protocol; 'https' causes OpenSSL to be used
        # @return [Excon::Response]
        # @see https://github.com/geemus/excon/blob/master/lib/excon/connection.rb
        #
        def request(*args)
          authenticated_request(*args)
        end

        # Makes a request but with seperated arguments and parses the response to a hash
        #
        # @note #wrapped_request is the non-standard form of request introduced by mistake
        #
        # @param [String] method HTTP method to use for the request
        # @param [String] path   The absolute path for the request
        # @param [Array<Fixnum>] expected_responses HTTP response codes that have been successful
        # @param [Hash]  parameters Keys and values for JSON
        # @option parameters [String] :account_id The scoping account if required
        #
        # @return [Hash]
        def wrapped_request(method, path, expected_responses, parameters = {})
          _wrapped_request(method, path, expected_responses, parameters)
        end

        private

        # Wrapped request is the non-standard form of request introduced by mistake
        #
        # @param [String] method HTTP method to use for the request
        # @param [String] path   The absolute path for the request
        # @param [Array<Fixnum>] expected_responses HTTP response codes that have been successful
        # @param [Hash]  parameters Keys and values for JSON
        # @option parameters [String] :account_id The scoping account if required
        #
        # @return [Hash]
        def _wrapped_request(method, path, expected_responses, parameters = {})
          request_options = {
            method: method.to_s.upcase,
            path: path,
            expects: expected_responses
          }

          query = {}

          # Select the account to scope for this request
          account = scoped_account(parameters.fetch(:account_id, nil))
          query[:account_id] = account if account
          query[:nested] = parameters.delete(:nested) if parameters.key?(:nested)
          request_options[:query] = query unless query.empty?

          request_options[:body] = Fog::JSON.encode(parameters) unless parameters.empty?

          response = make_request(request_options)

          # FIXME: We should revert to returning the Excon::Request after a suitable
          # configuration option is in place to switch back to this incorrect behaviour
          if response.body.empty?
            response
          else
            Fog::JSON.decode(response.body)
          end
        end

        # Queries the API and tries to select the most suitable official Image
        # to use if the user chooses not to select their own.
        #
        # @return [String] if image is found, the image's identifier
        # @return [NilClass] if no image found or an error occured
        #
        def select_default_image
          Fog::Brightbox::Compute::ImageSelector.new(list_images).latest_ubuntu
        end
      end
    end
  end
end
