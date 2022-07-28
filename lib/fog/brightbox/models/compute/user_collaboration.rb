module Fog
  module Brightbox
    class Compute
      class UserCollaboration < Fog::Brightbox::Model
        identity :id
        # resource_type is buggy for this resource
        attribute :url

        attribute :status
        attribute :email
        attribute :role
        attribute :role_label
        attribute :account
        attribute :user
        attribute :inviter

        def account_id
          account["id"] || account[:id]
        end

        def accept
          requires :identity
          data = service.accept_user_collaboration(identity)
          merge_attributes(data)
          true
        end

        def reject
          requires :identity
          data = service.reject_user_collaboration(identity)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          data = service.delete_user_collaboration(identity)
          merge_attributes(data)
          true
        end
      end
    end
  end
end
