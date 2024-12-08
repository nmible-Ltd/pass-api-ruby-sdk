module PASS
  class Arm < PASS::Resource
    validates :title, presence: true

    attribute :title, :string
    attribute :created_at, :time
    attribute :updated_at, :time
    attribute :deleted_at, :time

    attr_accessor :id,
                  :study_id

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

#      def has_one
#        {
#          :study_id => OpenStruct.new(type: :studies, label: :study)
#        }
#      end
    end
  end
end
