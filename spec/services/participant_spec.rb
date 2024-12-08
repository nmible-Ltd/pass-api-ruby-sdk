RSpec.describe 'PASS::Participant' do
  context 'when listing participants' do
    before do
      @participants = PASS::Participant.list
    end

    it 'should return a list of participants' do
      expect(@participants).to be_kind_of(Array)
      expect(@participants.first).to be_kind_of(PASS::Participant)
      expect(@participants.first.year_of_birth).to be_kind_of(Integer)
    end
  end

  context 'with a valid study, visit schedule, arm and site' do
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
      site_attributes = SiteFixture.valid
      site_attributes[:country_id] = @country.id
      site_attributes[:study_id] = @study.id
      @site = PASS::Site.new
      @site.assign_attributes(site_attributes)
      @site.save
    end

    it 'should be able to create a participant' do
      participant_attributes = {
        client_id: 'OMAR-1111111',
        year_of_birth: 1984,
        enrollment_date: Date.today,
        arm_id: @arm.id,
        site_id: @site.id
      }
      @participant = PASS::Participant.new
      @participant.assign_attributes(participant_attributes)
      @participant.save
      expect(@participant.valid?)
      expect(@participant.id).to be_present
      expect(@participant.arm_id).to eq(@arm.id)
      expect(@participant.site_id).to eq(@site.id)
    end

    after do
      begin
        @participant.destroy
      ensure
        @arm.destroy
        @visit_schedule.destroy
        @site.destroy
        @study.destroy
      end
    end

  end

  context 'when listing participants with a filter of client_id' do
    before do
      @client_id = 'arm-1-onboarded'
      @participants = PASS::Participant.list(filters: {client_id: @client_id})
    end

    it 'should return a list of participants of size 1 with the right client_id' do
      expect(@participants).to be_kind_of(Array)
      expect(@participants.size).to eq(1)
      expect(@participants.first).to be_kind_of(PASS::Participant)
      expect(@participants.first.client_id).to eq(@client_id)
    end
  end
end
