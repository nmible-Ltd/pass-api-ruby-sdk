module PASS
  class Resource
    include ActiveModel::Validations
    include ActiveModel::Attributes

    def save
      if self.id.present?
        update
      else
        create
      end
    end

    def create
      raise NotImplementedError
    end

    def update
      raise NotImplementedError
    end

    def assign_attributes(hash={})
      hash.each do |k, v|
        self.send("#{k.to_s}=", v)
      end
    end

    def api_type
      self.class.to_s.split('::').last.downcase.pluralize
    end

    def api_attributes
      attributes.transform_keys { |k| k.camelize(:lower) }
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

      def list
        raise NotImplementedError
      end

      def extract_data_from_item(item)
        attributes_hash = item[:attributes].inject({}) do |mem, (k,v)|
          mem[k.to_s.underscore.to_sym] = v
          mem
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

    end
  end
end
