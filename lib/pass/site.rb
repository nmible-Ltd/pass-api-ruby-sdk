require 'pp'

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
    attribute :travel_rate_value, :string
    attribute :travel_rate_unit_of_measurement, :string
    attribute :poc_name, :string
    attribute :poc_phone_number, :string
    attribute :poc_email, :string
    attribute :pi_name, :string
    attribute :approval_state, :string
    attribute :notes, :string
    attribute :draft_info, :string

    attr_accessor :id,
                  :study_country_id


    def create_endpoint
      'sites'
    end

    def destroy_endpoint
      "sites/#{id}"
    end

    class << self
      def get_endpoint(id)
        "sites/#{id}"
      end

      def list(filters: {})
        response = PASS::Client.instance.connection.get 'sites' do |request|
          request.params["page[size]"] = 10000000 # TODO: Remove this
          request.params["include"] = "studyCountry"
#           active_query_filters(filters).each do |k, v|
#             request.params["filter[#{k}]"] = v
#           end
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
          :study_country_id => OpenStruct.new(type: "study-countries", label: :studyCountry),
        }
      end

      def query_filters
        %w(country study number)
      end
    end
  end
end
