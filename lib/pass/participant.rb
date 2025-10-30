module PASS
  class Participant < PASS::Resource
    validates :client_id, :year_of_birth, :enrolment_date,
              :instruction_email_sent, :screening_failed,
              :requires_pin_change,
              presence: true

    attribute :screening_number, :string
    attribute :randomisation_number, :string
    attribute :client_id, :string
    attribute :login_id, :string
    attribute :randomisation_number_assigned_at, :date
    attribute :year_of_birth, :integer
    attribute :enrolment_date, :string
    attribute :screening_date, :string
    attribute :email, :string
    attribute :instruction_email_sent, :boolean, default: false
    attribute :screening_failed, :boolean, default: false
    attribute :pin_expires_at, :time
    attribute :requires_pin_change, :boolean, default: false
    attribute :onboarded_at, :date
    attribute :tax_compliant, :boolean, default: nil
    attribute :tax_requirement, :string, default: nil

    attr_accessor :id,
                  :arm_id,
                  :site_id

    def create_endpoint
      'participants'
    end

    def destroy_endpoint
      "participants/#{id}"
    end

    class << self
      def list(filters: {})
        response = PASS::Client.instance.connection.get 'participants' do |request|
          # TODO: Remove this
          request.params["page[limit]"] = 10000000
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
          :arm_id => OpenStruct.new(type: :arms, label: :arm),
          :site_id => OpenStruct.new(type: :sites, label: :site)
        }
      end

      def query_filters
        %w(clientId)
      end
    end
  end
end
