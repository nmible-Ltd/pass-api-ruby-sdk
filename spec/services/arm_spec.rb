RSpec.describe 'PASS::Arm' do
  context 'when listing arms' do
    before do
      @arms = PASS::Arm.list
    end

    it 'should return a list of arms' do
      expect(@arms).to be_kind_of(Array)
      expect(@arms.first).to be_kind_of(PASS::Arm)
      expect(@arms.first.title).to be_kind_of(String)
    end
  end

  context 'with a valid study and visit schedule and valid arm attributes' do
    before do
      study_attributes = StudyFixture.valid
      @country = PASS::Country.list(filters: {code: 'US'}).first
      @study = PASS::Study.new
      @study.assign_attributes(study_attributes)
      @study.save
      visit_schedule_attributes = {study_id: @study.id}
      @visit_schedule = PASS::VisitSchedule.new
      @visit_schedule.assign_attributes(visit_schedule_attributes)
      @visit_schedule.save
    end

    it 'should be able to create an arm' do
      attributes = {
        visit_schedule_id: @visit_schedule.id,
        title: 'Example Arm'
      }
      @arm = PASS::Arm.new
      @arm.assign_attributes(attributes)
      @arm.save
      expect(@arm.valid?)
      expect(@arm.id).to be_present
      expect(@arm.visit_schedule_id).to eq(@visit_schedule.id)
    end

    after do
      begin
        @arm.destroy
      ensure
        @visit_schedule.destroy
        @study.destroy
      end
    end
  end
end
