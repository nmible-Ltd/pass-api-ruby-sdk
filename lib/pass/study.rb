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
    attribute :translations, :string

    attr_accessor :id,
                  :country_ids,
                  :currency_ids,
                  :language_ids,
                  :expense_type_ids,
                  :default_language_id,
                  :default_currency_id

    def create_endpoint
      'studies'
    end

    def destroy_endpoint
      "studies/#{id}"
    end

    class << self
      def get_endpoint(id)
        "studies/#{id}"
      end

      def list(filters: {})
        response = PASS::Client.instance.connection.get 'studies' do |request|
          request.params["page[size]"] = 10000000 # TODO: Remove this
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
          :default_language_id => OpenStruct.new(type: :languages, label: :defaultLanguage),
          :default_currency_id => OpenStruct.new(type: :currencies, label: :defaultCurrency)
        }
      end

      def has_many
        {
          #:country_ids => OpenStruct.new(type: :countries, label: :countries),
          :expense_type_ids => OpenStruct.new(type: "expense-types", label: :expenseTypes),
          :currency_ids => OpenStruct.new(type: :currencies, label: :supportedCurrencies),
          :language_ids => OpenStruct.new(type: :languages, label: :supportedLanguages)
        }
      end

    end
  end
end
