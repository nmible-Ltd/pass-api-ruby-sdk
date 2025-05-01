module PASS
  class VisitSchedule < PASS::Resource
    attr_accessor :id, :study_id

    def create_endpoint
      'visit-schedules'
    end

    def destroy_endpoint
      "visit-schedules/#{id}"
    end

    class << self
      def list(filters: {})
        response = PASS::Client.instance.connection.get list_endpoint do |request|
          # TODO: Remove this
          request.params["page[size]"] = 10000000
          active_query_filters(filters).each do |k, v|
            request.params["filter[#{k}]"] = v
          end
        end
        collection = extract_list_from_response(response)
        query_filters.each do |filter|
          filters.delete(filter.to_sym)
        end
        filter_collection(filters, collection)
      end


      def list_endpoint
        "visit-schedules"
      end

      def has_one
        {
          :study_id => OpenStruct.new(type: :studies, label: :study)
        }
      end

      def query_filters
        %w(study)
      end
    end

  end
end
