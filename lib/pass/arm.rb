module PASS
  class Arm
    include PASS::Resources

    attr_accessor :id,
                  :title,
                  :created_at,
                  :updated_at,
                  :deleted_at

    class << self
      def list(filters: {})
        response = PASS::Client.instance.connection.get 'arms'
        collection = response.body[:data].map do |item|
          new(extract_data_from_item(item))
        end
        filter_collection(filters, collection)
      end
    end

  end
end
