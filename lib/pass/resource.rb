require 'pp'

module PASS
  class Resource
    include ActiveModel::Validations
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    def save
      if self.id.present?
        update
      else
        create
      end
    end

    def create
      response = PASS::Client.instance.connection.post create_endpoint do |req|
        req.body = api_create_attributes
      end
      if response.success?
        self.id = response.body[:data][:id]
      else
        pp response.body
      end
    end

    def create_endpoint
      raise NotImplementedError
    end

    def update
      raise NotImplementedError
    end

    def destroy
      PASS::Client.instance.connection.delete destroy_endpoint
    end

    def destroy_endpoint
      raise NotImplementedError
    end

    def assign_attributes(hash={})
      hash.each do |k, v|
        self.send("#{k.to_s}=", v)
      end
    end

    def api_type
      self.class.to_s.split('::').last.underscore.dasherize.pluralize.downcase
    end

    def api_attributes
      attributes.transform_keys { |k| k.camelize(:lower) }
    end

    def api_create_attributes
      attrs = {
        data: {
          type: api_type,
          attributes: api_attributes,
        }
      }
      self.class.has_many.each do |(k,v)|
        attrs[:data][:relationships] ||= {}
        relationship = self.send(k)
        if relationship.present?
          attrs[:data][:relationships][v.label] ||= {}
          attrs[:data][:relationships][v.label][:data] ||= {}
          relationship.each_with_index do |item, idx|
            attrs[:data][:relationships][v.label][:data][idx] ||= {}
            attrs[:data][:relationships][v.label][:data][idx][:type] = v.type
            attrs[:data][:relationships][v.label][:data][idx][:id] = item
          end
        end
      end
      self.class.has_one.each do |(k, v)|
        attrs[:data][:relationships] ||= {}
        relationship = self.send(k)
        if relationship.present?
          attrs[:data][:relationships][v.label] ||= {}
          attrs[:data][:relationships][v.label][:data] ||= {}
          attrs[:data][:relationships][v.label][:data][:type] = v.type
          attrs[:data][:relationships][v.label][:data][:id] = relationship
        end
      end
      attrs
    end


    class << self
      def filtered_objects_from_response(response, filters)
        collection = response.body[:data].map do |item|
          obj = new
          obj.assign_attributes(extract_data_from_item(item))
          obj
        end
        filter_collection(filters, collection)
      end

      def list(filters: {})
        response = PASS::Client.instance.connection.get list_endpoint
        collection = response.body[:data].map do |item|
          obj = new
          obj.assign_attributes(extract_data_from_item(item))
          obj
        end
        filter_collection(filters, collection)
      end

      def list_endpoint
        raise NotImplementedError
      end

      def extract_data_from_item(item)
        attributes_hash = item[:attributes].inject({}) do |mem, (k,v)|
          mem[k.to_s.underscore.to_sym] = v
          mem
        end
        has_many.each do |k, v|
          val = item[:relationships][v.label]
          attributes_hash[k] = val[:data].map do |item|
            item[:id].to_i
          end
        end
        has_one.each do |k, v|
          attributes_hash[k] = item[:relationships][v.label][:data][:id]
        end
        attributes_hash[:id] = item[:id]
        attributes_hash
      end

      def filter_collection(filters, collection)
        if filters.any?
          collection.select { |obj|
            filters.all? do |k, v|
              obj.send(k) == v
            end
          }
        else
          collection
        end
      end

      def active_query_filters(filters={})
        returning = if query_filters.any?
          filters.select do |k, v|
            query_filters.include?(k.to_s)
          end || {}
        else
          {}
        end
        returning
      end

      def query_filters
        []
      end

      def has_one
        {}
      end

      def has_many
        {}
      end

    end
  end
end
