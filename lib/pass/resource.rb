require 'pp'

module PASS
  class Resource
    include ActiveModel::Validations
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    attribute :created_at, :time
    attribute :updated_at, :time
    attribute :deleted_at, :time

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
        puts "object"
        pp self
        puts "attributes"
        pp api_create_attributes
        puts "response-body"
        pp response.body
      end
    end

    def create_endpoint
      raise NotImplementedError
    end

    def update
      response = PASS::Client.instance.connection.put update_endpoint do |req|
        req.body = api_create_attributes(include_id: true)
      end
      unless response.success?
        raise "Failed to update"
      end
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
      attributes.transform_keys { |k| k.camelize(:lower) }#.reject { |k,v| v.nil? }
    end

    def api_create_attributes(include_id: false)
      attrs = {
        data: {
          type: api_type,
          attributes: api_attributes,
        }
      }
      attrs[:data][:id] = id if include_id

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
        puts response.inspect
        collection = response.body[:data].map do |item|
          obj = new
          obj.assign_attributes(extract_data_from_item(item))
          obj
        end
        filter_collection(filters, collection)
      end

      def get(id)
        response = PASS::Client.instance.connection.get get_endpoint(id)
        obj = new
        obj.assign_attributes(extract_data_from_item(response.body[:data]))
        obj
      end

      def list(filters: {}, debug: false)
        response = PASS::Client.instance.connection.get list_endpoint
        collection = extract_list_from_response(response)
        pp collection if debug
        filter_collection(filters, collection)
      end

      def extract_list_from_response(response)
        response.body[:data].map do |item|
          obj = new
          obj.assign_attributes(extract_data_from_item(item))
          obj
        end
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
