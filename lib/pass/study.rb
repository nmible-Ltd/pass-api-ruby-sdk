require 'pp'

module PASS
  class Study < PASS::Resource
    validates :name, :sponsor, :protocol_number, :phase,
              :service_agreement_type, :status, :description,
              :max_budget, :notification_percentage,
              presence: true

    validates :sponsor, length: {minimum: 6}

    attribute :name, :string
    attribute :sponsor, :string
    attribute :status, :string
    attribute :service_agreement_type, :string
    attribute :status, :string
    attribute :description, :string
    attribute :max_budget, :string
    attribute :notification_percentage, :string
    attribute :phase, :string
    attribute :protocol_number, :string
    attribute :protocol_approval, :string
    attribute :first_participant_in, :time
    attribute :last_participant_in, :time
    attribute :last_participant_last_visit, :time
    attribute :database_lock, :time
    attribute :clinical_study_report, :time
    attribute :created_at, :time
    attribute :updated_at, :time
    attribute :deleted_at, :time

    attr_accessor :id

    def create
      response = PASS::Client.instance.connection.post 'studies' do |req|
        req.body = create_attributes
      end
      pp response.body
    end

    def create_attributes
      {
        data: {
          type: api_type,
          attributes: api_attributes,
          relationships: {}
        }
      }
    end


    class << self
      def list(filters: {})
        response = PASS::Client.instance.connection.get 'studies'
        collection = response.body[:data].map do |item|
          obj = new
          obj.assign_attributes(extract_data_from_item(item))
          obj
        end
        filter_collection(filters, collection)
      end

      def has_one
      end

      def has_many
        {
          :countries => :countries
        }
      end

    end
  end
end
