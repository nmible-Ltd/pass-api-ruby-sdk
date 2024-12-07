module PASS
  class Study

    attr_accessor :id,
                  :name,
                  :sponsor,
                  :protocol_number,
                  :phase,
                  :service_agreement_type,
                  :status,
                  :description,
                  :max_budget,
                  :notification_percentage,
                  :protocol_approval,
                  :first_participant_in,
                  :last_participant_in,
                  :last_participant_last_visit,
                  :database_lock,
                  :clinical_study_report,
                  :created_at,
                  :updated_at,
                  :deleted_at

    def initialize(attributes)
      attributes.each do |k, v|
        self.send("#{k.to_s}=", v)
      end
    end


    class << self
      def list(filters: {})
        response = PASS::Client.instance.connection.get 'studies'
        collection = response.body[:data].map do |item|
          new(extract_data_from_item(item))
        end
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
