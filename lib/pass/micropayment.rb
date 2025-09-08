module PASS
  class Micropayment < PASS::Resource
    validates_presence_of :label, :status, :amount

    attribute :label, :string
    attribute :status, :string
    attribute :amount, :string
    attribute :rejection_reason, :string

    attr_accessor :id,
                  :participant_id,
                  :payment_id

    def create_endpoint
      'micropayments'
    end

    def destroy_endpoint
      "visits/#{id}"
    end

    class << self
      def list(filters: {})
        response = PASS::Client.instance.connection.get list_endpoint do |request|
          request.params["page[limit]"] = 10000000 # TODO: Remove this
        end
        collection = extract_list_from_response(response)
        filter_collection(filters, collection)
      end

      def list_endpoint
        'micropayments'
      end

      def has_one
        {
          :participant_id => OpenStruct.new(type: :participants, label: :participant)
        }
      end

    end
  end
end
