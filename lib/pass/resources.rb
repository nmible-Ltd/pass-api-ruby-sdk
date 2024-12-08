module PASS
  module Resources
    ALLOWED_VALIDATION_ON = [:create, :update]


    def self.included(base)
      @@validations = {}
      ALLOWED_VALIDATION_ON.each do |validation_on|
        @@validations[validation_on] = {
          :presence => []
        }
      end

      base.extend(ClassMethods)
    end

    def initialize(attributes={})
      attributes.each do |k, v|
        self.send("#{k.to_s}=", v)
      end
    end

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

    def validate_on_create
      @@validations[:create]
    end

    module ClassMethods

      def attr_accessor(*vars)
        @attributes ||= []
        @attributes.concat vars
        super(*vars)
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

      def validates_presence_of(*vars)
        puts vars.inspect
        validation_on = extract_validation_on(vars)
        puts validation_on.inspect
        @validations[validation_on][:presence] << vars
        @validations[validation_on][:presence].compact!
        puts vars.inspect
      end

      def extract_validation_on(vars)
        validation_on = vars.select { |x| x.kind_of?(Hash) && x.keys.include?(:on) }.first[:on]
        vars.reject! { |x| x.kind_of?(Hash) && x.keys.include?(:on) }
        raise NotImplementedError, "#{validation_on} not an allowed validation on mechanism" unless ALLOWED_VALIDATION_ON.include?(validation_on)
        validation_on
      end


    end
  end
end
