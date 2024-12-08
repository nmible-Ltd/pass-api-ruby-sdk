RSpec.describe 'PASS::Visit' do
  context 'when listing visits' do
    before do
      @visits = PASS::Visit.list
    end

    it 'should return a list of visits' do
      expect(@visits).to be_kind_of(Array)
      expect(@visits.first).to be_kind_of(PASS::Visit)
      expect(@visits.first.name).to be_kind_of(String)
    end
  end

  context 'with a valid study, visit schedule and arm' do
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
      arm_attributes = {
        visit_schedule_id: @visit_schedule.id,
        title: 'Example Arm'
      }
      @arm = PASS::Arm.new
      @arm.assign_attributes(arm_attributes)
      @arm.save
    end

    it 'should be able to create a visit' do
      visit_attributes = {
        name: 'Screening',
        time_frame: 0,
        time_window: 7,
        screening: true,
        stipend_value: '10.00',
        arm_id: @arm.id
      }
      @visit = PASS::Visit.new
      @visit.assign_attributes(visit_attributes)
      @visit.save
      expect(@visit.valid?)
      expect(@visit.id).to be_present
      expect(@visit.arm_id).to eq(@arm.id)
    end

    after do
      begin
        @visit.destroy
      ensure
        @arm.destroy
        @visit_schedule.destroy
        @study.destroy
      end
    end
  end

  context 'when listing visits with a filter of name and an arm attached' do
    before do
      study_attributes = StudyFixture.valid
      @study = PASS::Study.new
      @study.assign_attributes(study_attributes)
      @study.save
      visit_schedule_attributes = {study_id: @study.id}
      @visit_schedule = PASS::VisitSchedule.new
      @visit_schedule.assign_attributes(visit_schedule_attributes)
      @visit_schedule.save
      arm_attributes = {
        visit_schedule_id: @visit_schedule.id,
        title: 'Example Arm'
      }
      @arm = PASS::Arm.new
      @arm.assign_attributes(arm_attributes)
      @arm.save
      @visit_attributes = {
        name: 'Screening',
        time_frame: 0,
        time_window: 7,
        screening: true,
        stipend_value: '10.00',
        arm_id: @arm.id
      }
      @visit = PASS::Visit.new
      @visit.assign_attributes(@visit_attributes)
      @visit.save
      @visits = PASS::Visit.list(filters: {arm_id: @arm.id, name: @visit_attributes[:name]})
    end

    it 'should return a list of visits of size 1 with the right name' do
      expect(@visits).to be_kind_of(Array)
      expect(@visits.size).to eq(1)
      expect(@visits.first).to be_kind_of(PASS::Visit)
      expect(@visits.first.name).to eq(@visit_attributes[:name])
    end

    after do
      begin
        @visit.destroy
      ensure
        @arm.destroy
        @visit_schedule.destroy
        @study.destroy
      end
    end
  end


  context 'when creating a visit with an arm and a study' do
    before do
    end
  end
end
