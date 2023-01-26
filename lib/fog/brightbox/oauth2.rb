module Fog
  module Brightbox
    # This module covers Brightbox's partial implementation of OAuth 2.0
    # and enables fog clients to implement several authentictication strategies
    #
    # @see http://tools.ietf.org/html/draft-ietf-oauth-v2-10
    #
    module OAuth2
      TWO_FACTOR_HEADER = "X-Brightbox-OTP".freeze

      class TwoFactorMissingError < StandardError; end

      # This builds the simplest form of requesting an access token
      # based on the arguments passed in
      #
      # @param [Fog::Core::Connection] connection
      # @param [CredentialSet] credentials
      #
      # @return [Excon::Response]
      # @raise [Excon::Errors::Unauthorized] if the credentials are rejected by the server
      # @raise [Fog::Brightbox::OAuth2::TwoFactorMissingError] if opted in to 2FA and server reports header is required
      def request_access_token(connection, credentials)
        token_strategy = credentials.best_grant_strategy

        if two_factor?
          # When 2FA opt-in is set, we can expect 401 responses as well
          response = connection.request(
            path: "/token",
            expects: [200, 401],
            headers: token_strategy.headers,
            method: "POST",
            body: Fog::JSON.encode(token_strategy.authorization_body_data)
          )

          if response.status == 401 && response.headers[Fog::Brightbox::OAuth2::TWO_FACTOR_HEADER] == "required"
            raise TwoFactorMissingError
          elsif response.status == 401
            raise Excon::Errors.status_error({ expects: 200 }, status: 401)
          else
            response
          end
        else
          # Use classic behaviour and return Excon::
          connection.request(
            path: "/token",
            expects: 200,
            headers: token_strategy.headers,
            method: "POST",
            body: Fog::JSON.encode(token_strategy.authorization_body_data)
          )
        end
      end

      # Encapsulates credentials required to request access tokens from the
      # Brightbox authorisation servers
      #
      # @todo Interface to update certain credentials (after password change)
      #
      class CredentialSet
        attr_reader :client_id, :client_secret, :username, :password
        attr_reader :access_token, :refresh_token, :expires_in
        attr_reader :one_time_password
        #
        # @param [String] client_id
        # @param [String] client_secret
        # @param [Hash] options
        # @option options [String] :username
        # @option options [String] :password
        # @option options [String] :one_time_password One Time Password for Two Factor authentication
        #
        def initialize(client_id, client_secret, options = {})
          @client_id     = client_id
          @client_secret = client_secret
          @username      = options[:username]
          @password      = options[:password]
          @access_token  = options[:access_token]
          @refresh_token = options[:refresh_token]
          @expires_in    = options[:expires_in]
          @one_time_password = options[:one_time_password]
        end

        # Returns true if user details are available
        # @return [Boolean]
        def user_details?
          !!(@username && @password)
        end

        # Is an access token available for these credentials?
        def access_token?
          !!@access_token
        end

        # Is a refresh token available for these credentials?
        def refresh_token?
          !!@refresh_token
        end

        # Updates the credentials with newer tokens
        def update_tokens(access_token, refresh_token = nil, expires_in = nil)
          @access_token  = access_token
          @refresh_token = refresh_token
          @expires_in    = expires_in
        end

        # Based on available credentials returns the best strategy
        #
        # @todo Add a means to dictate which should or shouldn't be used
        #
        def best_grant_strategy
          if refresh_token?
            RefreshTokenStrategy.new(self)
          elsif user_details?
            UserCredentialsStrategy.new(self)
          else
            ClientCredentialsStrategy.new(self)
          end
        end
      end

      # This strategy class is the basis for OAuth2 grant types
      #
      # @abstract Need to implement {#authorization_body_data} to return a
      #   Hash matching the expected parameter form for the OAuth request
      #
      # @todo Strategies should be able to validate if credentials are suitable
      #   so just client credentials cannot be used with user strategies
      #
      class GrantTypeStrategy
        def initialize(credentials)
          @credentials = credentials
        end

        def authorization_body_data
          raise "Not implemented"
        end

        def authorization_header
          header_content = "#{@credentials.client_id}:#{@credentials.client_secret}"
          "Basic #{Base64.encode64(header_content).chomp}"
        end

        def headers
          {
            "Authorization" => authorization_header,
            "Content-Type" => "application/json"
          }
        end
      end

      # This implements client based authentication/authorization
      # based on the existing trust relationship using the
      # `client_credentials` grant type.
      #
      class ClientCredentialsStrategy < GrantTypeStrategy
        def authorization_body_data
          {
            "grant_type" => "client_credentials"
          }
        end
      end

      # This passes user details through so the returned token
      # carries the privileges of the user not account limited
      # by the client
      #
      class UserCredentialsStrategy < GrantTypeStrategy
        def authorization_body_data
          {
            "grant_type" => "password",
            "username"   => @credentials.username,
            "password"   => @credentials.password
          }
        end

        def headers
          {
            "Authorization" => authorization_header,
            "Content-Type" => "application/json"
          }.tap do |headers|
            if @credentials.one_time_password
              headers[TWO_FACTOR_HEADER] = @credentials.one_time_password
            end
          end
        end
      end

      # This strategy attempts to use a refresh_token gained during an earlier
      # request to reuse the credentials given originally
      #
      class RefreshTokenStrategy < GrantTypeStrategy
        def authorization_body_data
          {
            "grant_type"    => "refresh_token",
            "refresh_token" => @credentials.refresh_token
          }
        end
      end

      private

      # This updates the current credentials if passed a valid response
      #
      # @param [CredentialSet] credentials Credentials to update
      # @param [Excon::Response] response Response object to parse value from
      #
      def update_credentials_from_response(credentials, response)
        response_data = Fog::JSON.decode(response.body)
        credentials.update_tokens(response_data["access_token"], response_data["refresh_token"], response_data["expires_in"])
      end
    end
  end
end
