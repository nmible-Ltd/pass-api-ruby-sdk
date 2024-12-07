require 'pp'

module PASS
  class Site
    include PASS::Resources

    attr_accessor :id,
                  :created_at,
                  :updated_at,
                  :deleted_at,
                  :name,
                  :number,
                  :status,
                  :line1,
                  :line2,
                  :line3,
                  :town,
                  :postcode,
                  :max_patient_count,
                  :travel_rate_value,
                  :travel_rate_unit_of_measurement,
                  :point_of_contact_name,
                  :point_of_contact_phone_number,
                  :point_of_contact_email,
                  :study_id


    class << self
      def list(filters: {})
        query_filters = %w(country study study.visitSchedule.id)
        active_query_filters = filters.select do |k, v|
          query_filters.include?(k.to_s)
        end || {}

        response = PASS::Client.instance.connection.get 'sites' do |request|
          active_query_filters.each do |k, v|
            request.params["filter[#{k}]"] = v
          end
        end

        query_filters.each do |filter|
          filters.delete(filter.to_sym)
        end

        response.body[:data].map do |item|
          attributes = extract_data_from_item(item)
          attributes[:study_id] = item[:relationships][:study][:data][:id]
          new(attributes)
        end
      end
    end
  end
end
