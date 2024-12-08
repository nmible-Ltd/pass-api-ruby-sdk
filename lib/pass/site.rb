module PASS
  class Site < PASS::Resource
    validates :name, :number, :status, :line1, :line2,
              :postcode, :max_patient_count,
              :travel_rate_unit_of_measurement,
              :point_of_contact_name,
              :point_of_contact_phone_number,
              :point_of_contact_email,
              presence: true

    attribute :name, :string
    attribute :number, :string
    attribute :status, :string
    attribute :line1, :string
    attribute :line2, :string
    attribute :line3, :string
    attribute :town, :string
    attribute :postcode, :string
    attribute :max_patient_count, :integer
    attribute :travel_rate_value, :decimal
    attribute :travel_rate_unit_of_measurement, :string
    attribute :point_of_contact_name, :string
    attribute :point_of_contact_phone_number, :string
    attribute :point_of_contact_email, :string
    attribute :created_at, :time
    attribute :updated_at, :time
    attribute :deleted_at, :time

    attr_accessor :id,
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

        collection = response.body[:data].map do |item|
          obj = new
          obj.assign_attributes(extract_data_from_item(item))
          obj
        end
        filter_collection(filters, collection)
      end

      def has_one
        {
          :study_id => OpenStruct.new(type: :study, label: :study)
        }
      end
    end
  end
end
