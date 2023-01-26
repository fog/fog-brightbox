require "spec_helper"

describe Fog::Brightbox::Compute, "#get_access_token" do
  before do
    @new_access_token = "0987654321"
    @new_refresh_token = "5432167890"

    @options = {
      brightbox_client_id: "app-12345",
      brightbox_secret: "1234567890",
      brightbox_username: "jason.null@brightbox.com",
      brightbox_password: "HR4life",
      brightbox_support_two_factor: true,
      brightbox_one_time_password: "123456"
    }
    @service = Fog::Brightbox::Compute.new(@options)
  end

  describe "when user does not have 2FA enabled" do
    describe "and authenticates correctly" do
      before do
        stub_authentication_request(auth_correct: true)

        assert @service.two_factor?
      end

      describe "without !" do
        it "updates credentials" do
          token = @service.get_access_token
          assert_equal "0987654321", token

          assert_equal token, @service.access_token
        end
      end

      describe "with !" do
        it "updates credentials" do
          token = @service.get_access_token!
          assert_equal "0987654321", token

          assert_equal token, @service.access_token
        end
      end
    end

    describe "and authenticates incorrectly" do
      before do
        stub_authentication_request(auth_correct: false)

        assert @service.two_factor?
      end

      describe "without !" do
        it "returns nil" do
          assert_nil @service.get_access_token

          assert_nil @service.access_token
          assert_nil @service.refresh_token
        end
      end

      describe "with !" do
        it "raises an error" do
          begin
            @service.get_access_token!
          rescue Excon::Error::Unauthorized
            assert_nil @service.access_token
            assert_nil @service.refresh_token
          end
        end
      end
    end
  end

  describe "when user does have 2FA enabled" do
    describe "and authenticates correctly" do
      describe "without OTP" do
        before do
          stub_authentication_request(auth_correct: true,
                                      two_factor_user: true)

          assert @service.two_factor?
        end

        describe "without !" do
          it "returns nil" do
            assert_nil @service.get_access_token

            assert_nil @service.access_token
            assert_nil @service.refresh_token
          end
        end

        describe "with !" do
          it "raises an error" do
            begin
              @service.get_access_token!
            rescue Fog::Brightbox::OAuth2::TwoFactorMissingError
              assert_nil @service.access_token
              assert_nil @service.refresh_token
            end
          end
        end
      end

      describe "with OTP" do
        before do
          stub_authentication_request(auth_correct: true,
                                      two_factor_user: true,
                                      otp_sent: true)

          assert @service.two_factor?
        end

        describe "without !" do
          it "updates credentials" do
            token = @service.get_access_token
            assert_equal "0987654321", token

            assert_equal token, @service.access_token
          end
        end

        describe "with !" do
          it "updates credentials" do
            token = @service.get_access_token!
            assert_equal "0987654321", token

            assert_equal token, @service.access_token
          end
        end
      end
    end

    describe "and authenticates incorrectly" do
      before do
        stub_authentication_request(auth_correct: false,
                                    two_factor_user: true)

        assert @service.two_factor?
      end

      describe "without !" do
        it "returns nil" do
          assert_nil @service.get_access_token

          assert_nil @service.access_token
          assert_nil @service.refresh_token
        end
      end

      describe "with !" do
        it "raises an error" do
          begin
            @service.get_access_token!
          rescue Fog::Brightbox::OAuth2::TwoFactorMissingError
            assert_nil @service.access_token
            assert_nil @service.refresh_token
          end
        end
      end
    end

    describe "without 2FA support enabled" do
      before do
        @options = {
          brightbox_client_id: "app-12345",
          brightbox_secret: "1234567890",
          brightbox_username: "jason.null@brightbox.com",
          brightbox_password: "HR4life",
          brightbox_support_two_factor: false,
          brightbox_one_time_password: "123456"
        }
        @service = Fog::Brightbox::Compute.new(@options)

        refute @service.two_factor?
      end

      describe "without !" do
        it "returns nil" do
          stub_authentication_request(auth_correct: false,
                                      two_factor_user: true)

          assert_nil @service.get_access_token

          assert_nil @service.access_token
          assert_nil @service.refresh_token
        end
      end

      describe "with !" do
        describe "when authentication incorrect" do
          it "raises an error" do
            stub_authentication_request(auth_correct: false,
                                        two_factor_user: true,
                                        otp_sent: true)

            begin
              @service.get_access_token!
            rescue Excon::Error::Unauthorized
              assert_nil @service.access_token
              assert_nil @service.refresh_token
            end
          end
        end

        describe "with missing OTP" do
          before do
            @options = {
              brightbox_client_id: "app-12345",
              brightbox_secret: "1234567890",
              brightbox_username: "jason.null@brightbox.com",
              brightbox_password: "HR4life",
              brightbox_support_two_factor: false
            }
            @service = Fog::Brightbox::Compute.new(@options)

            refute @service.two_factor?
          end

          it "raises an error" do
            stub_authentication_request(auth_correct: true,
                                        two_factor_user: true,
                                        otp_sent: false)

            begin
              @service.get_access_token!
            rescue Excon::Error::Unauthorized
              assert_nil @service.access_token
              assert_nil @service.refresh_token
            end
          end
        end
      end
    end
  end

  # @param auth_correct [Boolean] Treat username/password as correct
  # @param two_factor_user [Boolean] Is user protected by 2FA on server
  # @param otp_sent [Boolean] Is an OTP sent in the request?
  def stub_authentication_request(auth_correct: true,
                                  two_factor_user: false,
                                  otp_sent: nil)

    two_factor_supported = @service.two_factor?

    request = {
      headers: {
        "Authorization" => "Basic YXBwLTEyMzQ1OjEyMzQ1Njc4OTA=",
        "Content-Type" => "application/json"
      },
      body: {
        grant_type: "password",
        username: "jason.null@brightbox.com",
        password: "HR4life"
      }.to_json
    }.tap do |req|
      # Only expect the header if the service should send it
      # Without this, we stub a request that demands an OTP but it is not sent
      if two_factor_supported && otp_sent
        req[:headers]["X-Brightbox-OTP"] = "123456"
      end
    end

    # The cases we are testing are:
    #
    # * User does not use 2FA and authenticate
    # * User does not use 2FA and FAILS to authenticate
    # * User does use 2FA and authenticate
    # * User does use 2FA and FAILS to authenticate
    # * User does use 2FA and FAILS to send OTP
    #
    response = if two_factor_user && !otp_sent
                 # OTP required header
                 {
                   status: 401,
                   headers: {
                     "X-Brightbox-OTP" => "required"
                   },
                   body: { error: "invalid_client" }.to_json
                 }
               elsif !auth_correct
                 # No OTP header
                 {
                   status: 401,
                   headers: {},
                   body: { error: "invalid_client" }.to_json
                 }
               else
                 {
                   status: 200,
                   headers: {},
                   body: {
                     access_token: @new_access_token,
                     refresh_token: @new_refresh_token,
                     expires_in: 7200
                   }.to_json
                 }
               end

    stub_request(:post, "https://api.gb1.brightbox.com/token")
      .with(request)
      .to_return(response)
  end
end
