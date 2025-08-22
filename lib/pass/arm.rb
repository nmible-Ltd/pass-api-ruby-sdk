module PASS
  class Arm < PASS::Resource
    validates :title, presence: true

    attribute :title, :string

    attr_accessor :id,
                  :visit_schedule_id

    def create_endpoint
      'arms'
    end

    def destroy_endpoint
      "arms/#{id}"
    end

    class << self
      def list_endpoint
        'arms'
      end

      def list(filters: {})
        response = PASS::Client.instance.connection.get 'arms' do |request|
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

      def has_one
        {
          :study_country_id => OpenStruct.new(type: "study-countries", label: :studyCountry)
        }
      end

      def query_filters
        %w(study)
      end
    end
  end
end
