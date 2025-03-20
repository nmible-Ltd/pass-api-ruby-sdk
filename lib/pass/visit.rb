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
    attribute :translations, :json

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
        response = PASS::Client.instance.connection.get 'visits' do |request|
          request.params["page[size]"] = 10000000 # TODO: Remove this
        end
        collection = extract_list_from_response(response)
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

    end
  end
end
