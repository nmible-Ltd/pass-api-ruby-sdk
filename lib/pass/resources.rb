module PASS
  module Resources

    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize(attributes)
      attributes.each do |k, v|
        self.send("#{k.to_s}=", v)
      end
    end

    def save
      if self.id.exists?
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

    module ClassMethods
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
