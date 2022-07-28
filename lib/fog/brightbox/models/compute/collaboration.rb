module Fog
  module Brightbox
    class Compute
      class Collaboration < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :status

        attribute :email
        attribute :role
        attribute :role_label

        # Timestamps
        attribute :created_at, type: :time
        attribute :started_at, type: :time
        attribute :finished_at, type: :time

        # Links
        attribute :account
        attribute :user
        attribute :inviter

        def account_id
          account["id"] || account[:id]
        end

        def save
          raise Fog::Errors::Error.new("Resaving an existing object may create a duplicate") if identity

          options = {
            :role => role,
            :email => email
          }.delete_if { |_k, v| v.nil? || v == "" }

          data = service.create_collaboration(options)
          merge_attributes(data)
          true
        end

        def resend
          requires :identity
          data = service.resend_collaboration(identity)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          data = service.delete_collaboration(identity)
          merge_attributes(data)
          true
        end
      end
    end
  end
end
