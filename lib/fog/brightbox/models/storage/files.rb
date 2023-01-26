require "fog/brightbox/models/storage/file"

module Fog
  module Brightbox
    class Storage
      class Files < Fog::Collection
        attribute :directory
        attribute :limit
        attribute :marker
        attribute :path
        attribute :prefix

        model Fog::Brightbox::Storage::File

        def all(options = {})
          requires :directory
          options = {
            "limit"   => limit,
            "marker"  => marker,
            "path"    => path,
            "prefix"  => prefix
          }.merge!(options)
          merge_attributes(options)
          parent = directory.collection.get(
            directory.key,
            options
          )
          if parent
            load(parent.files.map { |file| file.attributes })
          else
            nil
          end
        end

        alias_method :each_file_this_page, :each
        def each
          if !block_given?
            self
          else
            subset = dup.all

            subset.each_file_this_page { |f| yield f }
            while subset.length == (subset.limit || 10_000)
              subset = subset.all(marker: subset.last.key)
              subset.each_file_this_page { |f| yield f }
            end

            self
          end
        end

        def get(key, &block)
          requires :directory
          data = service.get_object(directory.key, key, &block)
          file_data = data.headers.merge(
                                           body: data.body,
                                           key: key
                                         )
          new(file_data)
        rescue Fog::Brightbox::Storage::NotFound
          nil
        end

        def get_url(key)
          requires :directory
          return unless directory.public_url

          ::File.join(directory.public_url, Fog::Brightbox::Storage.escape(key, "/"))
        end

        def get_http_url(key, expires, options = {})
          requires :directory
          service.get_object_http_url(directory.key, key, expires, options)
        end

        def get_https_url(key, expires, options = {})
          requires :directory
          service.get_object_https_url(directory.key, key, expires, options)
        end

        def head(key, _options = {})
          requires :directory
          data = service.head_object(directory.key, key)
          file_data = data.headers.merge(
                                           key: key
                                         )
          new(file_data)
        rescue Fog::Brightbox::Storage::NotFound
          nil
        end

        def new(attributes = {})
          requires :directory
          super({ directory: directory }.merge!(attributes))
        end
      end
    end
  end
end
