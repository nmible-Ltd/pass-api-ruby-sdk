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
    attribute :code, :string
    attribute :use_study_code_for_login_id, :boolean, default: false
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
    attribute :approval_state, :string
    attribute :notes, :string
    attribute :draft_info, :string

    attr_accessor :id,
                  :country_ids,
                  :currency_ids,
                  :language_ids,
                  :expense_type_ids,
                  :supported_visit_type_ids,
                  :default_language_id,
                  :default_currency_id

    def create_endpoint
      'studies'
    end

    def destroy_endpoint
      "studies/#{id}"
    end

    class << self
      def list_endpoint
        'studies'
      end

      def get_endpoint(id)
        "studies/#{id}"
      end

      def has_one
        {
          :default_language_id => OpenStruct.new(type: :languages, label: :defaultLanguage),
        }
      end

      def has_many
        {
          :expense_type_ids => OpenStruct.new(type: "expense-types", label: :expenseTypes),
          :language_ids => OpenStruct.new(type: :languages, label: :supportedLanguages),
          :supported_visit_type_ids => OpenStruct.new(type: "visit-types", label: :supportedVisitTypes)
        }
      end

      def query_filters
        %w(protocolNumber)
      end

      def included_associations
        %w(defaultLanguage expenseTypes supportedLanguages supportedVisitTypes)
      end

    end
  end
end
