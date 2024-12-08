module PASS
  class VisitSchedule < PASS::Resource
    attr_accessor :id, :study_id

    def create_endpoint
      'visit-schedules'
    end

    def destroy_endpoint
      "visit-schedules/#{id}"
    end

    class << self
      def list_endpoint
        "visit-schedules"
      end

      def has_one
        {
          :study_id => OpenStruct.new(type: :studies, label: :study)
        }
      end
    end

  end
end
