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

    module ClassMethods
      def list_response(response)

      end

      def extract_data_from_item(item)
        attributes_hash = item[:attributes].inject({}) do |mem, (k,v)|
          mem[k.to_s.underscore.to_sym] = v
          mem
        end
        attributes_hash[:id] = item[:id]
        attributes_hash
      end

    end
  end
end
