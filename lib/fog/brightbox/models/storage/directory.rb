require "fog/brightbox/models/storage/files"

module Fog
  module Brightbox
    class Storage
      class Directory < Fog::Model
        identity :key, :aliases => "name"

        attribute :bytes, :aliases => "X-Container-Bytes-Used"
        attribute :count, :aliases => "X-Container-Object-Count"
        attribute :read_permissions, :aliases => "X-Container-Read"
        attribute :write_permissions, :aliases => "X-Container-Write"

        def destroy
          requires :key
          service.delete_container(key)
          true
        rescue Excon::Errors::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Brightbox::Storage::Files.new(
              :directory    => self,
              :service   => service
            )
          end
        end

        attr_writer :public

        def public_url
          requires :key
          @public_url ||= [service.management_url , Fog::Brightbox::Storage.escape(key, "/")].join("/")
        end

        def save
          requires :key
          options = {
            "read_permissions" => read_permissions,
            "write_permissions" => write_permissions
          }
          service.put_container(key, options)
          true
        end
      end
    end
  end
end
