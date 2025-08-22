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
          request.params["include"] = "visitSchedule"
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
          :visit_schedule_id => OpenStruct.new(type: "visit-schedules", label: :visitSchedule)
        }
      end
    end
  end
end
