require 'fog/core/collection'
require 'fog/brightbox/models/storage/directory'

module Fog
  module Storage
    class Brightbox

      class Directories < Fog::Collection

        model Fog::Storage::Brightbox::Directory

        HEADER_ATTRIBUTES = [
          'X-Container-Bytes-Used', 'X-Container-Object-Count', 'X-Container-Read',
          'X-Container-Write'
        ]

        def all
          data = service.get_containers.body
          load(data)
        end

        def get(key, options = {})
          data = service.get_container(key, options)
          directory = new(:key => key)
          for key, value in data.headers
            if HEADER_ATTRIBUTES.include?(key)
              directory.merge_attributes(key => value)
            end
          end
          directory.files.merge_attributes(options)
          directory.files.instance_variable_set(:@loaded, true)

          data.body.each do |file|
            directory.files << directory.files.new(file)
          end
          directory
        rescue Fog::Storage::Brightbox::NotFound
          nil
        end

      end

    end
  end
end
