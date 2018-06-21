require "fog/brightbox/models/storage/directory"

module Fog
  module Brightbox
    class Storage
      class Directories < Fog::Collection
        model Fog::Brightbox::Storage::Directory

        HEADER_ATTRIBUTES = %w(X-Container-Bytes-Used X-Container-Object-Count X-Container-Read X-Container-Write)

        def all
          data = service.get_containers.body
          load(data)
        end

        def get(key, options = {})
          data = service.get_container(key, options)
          directory = new(:key => key)
          data.headers.each do |header, value|
            if HEADER_ATTRIBUTES.include?(header)
              directory.merge_attributes(header => value)
            end
          end
          directory.files.merge_attributes(options)
          directory.files.instance_variable_set(:@loaded, true)

          data.body.each do |file|
            directory.files << directory.files.new(file)
          end
          directory
        rescue Fog::Brightbox::Storage::NotFound
          nil
        end
      end
    end
  end
end
