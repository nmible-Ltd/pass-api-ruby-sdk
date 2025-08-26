module PASS
  class Visit < PASS::Resource
    validates_presence_of :name, :time_frame, :time_window,
                          :screening, :randomisation, :stipend, :stipend_value,
                          presence: true

    attribute :name, :string
    attribute :time_frame, :integer, default: 0
    attribute :time_window, :integer, default: 0
    attribute :screening, :boolean, default: false
    attribute :randomisation, :boolean, default: false
    attribute :stipend, :boolean, default: false
    attribute :stipend_value, :string
    attribute :translations, :string # this is actually JSON

    attr_accessor :id,
                  :arm_id

    def create_endpoint
      'visits'
    end

    def destroy_endpoint
      "visits/#{id}"
    end

    class << self
      def list(filters: {})
        response = PASS::Client.instance.connection.get list_endpoint do |request|
          request.params["page[size]"] = 10000000 # TODO: Remove this
#           active_query_filters(filters).each do |k, v|
#             request.params["filter[#{k}]"] = v
#           end
        end
        collection = extract_list_from_response(response)
#         query_filters.each do |filter|
#           filters.delete(filter.to_sym)
#         end
        filter_collection(filters, collection)
      end

      def list_endpoint
        "visits"
      end

      def has_one
        {
          :arm_id => OpenStruct.new(type: :arms, label: :arm),
        }
      end

      def query_filters
        %w(arm name)
      end

    end
  end
end
