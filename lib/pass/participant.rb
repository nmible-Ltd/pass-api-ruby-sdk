module PASS
  class Participant
    include PASS::Resources

    attr_accessor :id,
                  :screening_number,
                  :randomisation_number,
                  :client_id,
                  :randomisation_number_assigned_at,
                  :year_of_birth,
                  :enrollment_date,
                  :screening_date,
                  :email,
                  :instruction_email_sent,
                  :participant_screen_failed,
                  :pin_expires_at,
                  :requires_pin_change,
                  :tax_compliant,
                  :created_at,
                  :updated_at,
                  :deleted_at,
                  :arm_id



    class << self
      def list(filters: {})
        response = PASS::Client.instance.connection.get 'participants' do |request|
          request.params["page[size]"] = 10000000 # TODO: Remove this
        end
        collection = response.body[:data].map do |item|
          attributes = extract_data_from_item(item)
          attributes[:arm_id] = item[:relationships][:arm][:data][:id]
          new(attributes)
        end
        filter_collection(filters, collection)
      end
    end
  end
end