RSpec.describe 'PASS::VisitSchedule' do
  context 'when listing visit-schedules' do
    before do
      @visit_schedules = PASS::VisitSchedule.list
    end

    it 'should return a list of visit-schedules' do
      expect(@visit_schedules).to be_kind_of(Array)
      expect(@visit_schedules.first).to be_kind_of(PASS::VisitSchedule)
    end
  end

  context "with a valid study" do
    before do
      study_attributes = StudyFixture.valid
      @study = PASS::Study.new
      @study.assign_attributes(study_attributes)
      @study.save
    end

    it 'should create a visit schedule' do
      attributes = {study_id: @study.id}
      @visit_schedule = PASS::VisitSchedule.new
      @visit_schedule.assign_attributes(attributes)
      @visit_schedule.save
      expect(@visit_schedule.valid?)
      expect(@visit_schedule.id).to be_present
      expect(@visit_schedule.study_id).to eq(@study.id)
    end

    after do
      begin
        @visit_schedule.destroy
      ensure
        @study.destroy
      end
    end
  end
end
