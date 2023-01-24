module Fog
  module Brightbox
    class Compute
      class ConfigMap < Fog::Brightbox::Model
        identity :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :data

        def save
          options = {
            name: name
          }.delete_if { |_k, v| v.nil? }

          payload = JSON.decode(attributes[:data])

          res = if persisted?
                  # update
                  options[:data] = payload
                  service.update_config_map(identity, options)
                else
                  # create
                  raise Fog::Errors::Error.new("'data' is required") if data.nil? || data.empty?
                  options[:data] = payload
                  service.create_config_map(options)
                end

          merge_attributes(res)
          true
        rescue StandardError => e
          raise Fog::Errors::Error.new(e.message)
          false
        end

        def destroy
          requires :identity
          res = service.delete_config_map(identity)
          merge_attributes(res)
          true
        end
      end
    end
  end
end
