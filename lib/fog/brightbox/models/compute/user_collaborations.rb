require "fog/brightbox/models/compute/user_collaboration"

module Fog
  module Brightbox
    class Compute
      class UserCollaborations < Fog::Collection
        model Fog::Brightbox::Compute::UserCollaboration

        def all
          data = service.list_user_collaborations
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_user_collaboration(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

        def destroy
          requires :identity
          service.delete_user_collaboration(identity)
          true
        end
      end
    end
  end
end
