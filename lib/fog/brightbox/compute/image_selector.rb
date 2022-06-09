module Fog
  module Brightbox
    class Compute
      #
      # This selects the preferred image to use based on a number of
      # conditions
      #
      class ImageSelector
        # Prepares a selector with the API output
        #
        # @param [Array<Hash>] images hash matching API output for {Fog::Brightbox::Compute#list_images}
        #
        def initialize(images)
          @images = images
        end

        # Returns current identifier of the latest version of Ubuntu
        #
        # The order of preference is:
        # * Only Official Brightbox images
        # * Only Ubuntu images
        # * Latest by name (alphanumeric sort)
        # * Latest by creation date
        #
        # @return [String] if image matches containing the identifier
        # @return [NilClass] if no image matches
        #
        def latest_ubuntu
          @images.select do |img|
            img["official"] == true &&
              img["status"] == "available" &&
              img["arch"] == "x86_64" &&
              img["name"] =~ /ubuntu/i
          end.sort do |a, b|
            # Reverse sort so "22.10" > "22.04"
            NameSorter.new(b["name"]).version <=> NameSorter.new(a["name"]).version
          end.first["id"]
        rescue StandardError
          nil
        end

        # Returns current identifier of the smallest official image
        #
        # @return [String] if image matches containing the identifier
        # @return [NilClass] if no image matches
        #
        def official_minimal
          @images.select do |img|
            img["official"] == true &&
              img["status"] == "available" &&
              img["virtual_size"] != 0
          end.sort_by do |img|
            img["disk_size"]
          end.first["id"]
        rescue StandardError
          nil
        end

        class NameSorter
          PATTERN = /\A(?<ubuntu>.*?)-(?<codename>.*?)-(?<version>[\d\.]*?)-(?<arch>.*?)/

          def initialize(name)
            @name = name
            @matches = name.match(PATTERN)
          end

          def arch
            @matches[:arch] || ""
          end

          def codename
            @matches[:codename] || ""
          end

          def ubuntu?
            @name.start_with?("ubuntu")
          end

          def version
            @matches[:version] || ""
          end
        end
      end
    end
  end
end
