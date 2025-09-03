module PASS
  class ParticipantVisit < PASS::Resource
    attribute :confirmed, :boolean, default: false
    attribute :actual_visit_timestamp, :date
    attribute :stipend_value, :string

    attr_accessor :id,
                  :participant_id,
                  :visit_id,
                  :selected_visit_type_id

    def update_endpoint
      "participant-visits/#{id}"
    end

    class << self
      def list(filters: {}, debug: false)
        response = PASS::Client.instance.connection.get list_endpoint do |request|
          request.params["page[limit]"] = 10000000 # TODO: Remove this
          active_query_filters(filters).each do |k, v|
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

      def query_filters
        %w(participant visit)
      end

      def list_endpoint
        'participant-visits'
      end

      def has_one
        {
          :visit_id => OpenStruct.new(type: :visits, label: :visit),
          :participant_id => OpenStruct.new(type: :participants, label: :participant),
          :selected_visit_type_id => OpenStruct.new(type: "visit-types", label: :selectedVisitType, optional: true)
        }
      end
    end
  end
end
