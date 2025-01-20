module PASS
  class Participant < PASS::Resource
    validates :client_id, :year_of_birth, :enrollment_date,
              :instruction_email_sent, :participant_screen_failed,
              :requires_pin_change,
              presence: true

    attribute :screening_number, :string
    attribute :randomisation_number, :string
    attribute :client_id, :string
    attribute :randomisation_number_assigned_at, :date
    attribute :year_of_birth, :integer
    attribute :enrollment_date, :date
    attribute :screening_date, :date
    attribute :email, :string
    attribute :instruction_email_sent, :boolean, default: false
    attribute :participant_screen_failed, :boolean, default: false
    attribute :pin_expires_at, :time
    attribute :requires_pin_change, :boolean, default: false
    attribute :tax_compliant, :boolean, default: false
    attribute :tax_requirement, :boolean, default: false

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
          request.params["page[size]"] = 10000000 # TODO: Remove this
        end
        collection = extract_list_from_response(response)
        filter_collection(filters, collection)
      end

      def has_one
        {
          :arm_id => OpenStruct.new(type: :arms, label: :arm),
          :site_id => OpenStruct.new(type: :sites, label: :site)
        }
      end

    end
  end
end
