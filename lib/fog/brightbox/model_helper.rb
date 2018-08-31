require "dry/inflector"

module Fog
  module Brightbox
    module ModelHelper
      def resource_name
        inflector = Dry::Inflector.new

        inflector.underscore(inflector.demodulize(self.class))
      end

      def collection_name
        Dry::Inflector.new.pluralize(resource_name)
      end
    end
  end
end
