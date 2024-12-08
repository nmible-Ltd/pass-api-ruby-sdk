module PASS
  class Visit
    include PASS::Resources

    attr_accessor :id,
                  :name,
                  :time_frame,
                  :time_window,
                  :screening,
                  :randomisation,
                  :stipend,
                  :stipend_value,
                  :created_at,
                  :updated_at,
                  :deleted_at,
                  :arm_id

    class << self
      def list(filters: {})
        response = PASS::Client.instance.connection.get 'visits' do |request|
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
