RSpec.describe 'PASS::ParticipantVisit' do
  context 'with an existing study with sites, arms, visits and participants' do
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
      @client_id = 'OMAR-1111111'
      participant_attributes = {
        client_id: @client_id,
        year_of_birth: 1984,
        enrollment_date: Date.today,
        arm_id: @arm.id,
        site_id: @site.id
      }
      @participant = PASS::Participant.new
      @participant.assign_attributes(participant_attributes)
      @participant.save
      @participant_visits = PASS::ParticipantVisit.list(filters: {participant: @participant.id, visit: @visit.id})
    end

    it 'should let me get a participant visits' do
      expect(@participant_visits).to be_kind_of(Array)
      expect(@participant_visits.first).to be_kind_of(PASS::ParticipantVisit)
      expect(@participant_visits.size).to eq(1)
      expect(@participant_visits.first.participant_id).to eq(@participant.id)
      expect(@participant_visits.first.visit_id).to eq(@visit.id)
    end

    context 'when updating the visit' do
      before do
        @participant_visit = @participant_visits.first
      end

      it 'should allow me to update the visit' do
        @participant_visit.actual_visit_timestamp = Date.today
        @participant_visit.stipend_value = "30.00"
        @participant_visit.confirmed = true
        PASS::Client.instance.set_debug(true)
        @participant_visit.save
        PASS::Client.instance.set_debug(false)
        @participant_visits = PASS::ParticipantVisit.list(filters: {participant: @participant.id, visit: @visit.id})
        @participant_visit = @participant_visits.first

        expect(@participant_visits).to be_kind_of(Array)
        expect(@participant_visits.first).to be_kind_of(PASS::ParticipantVisit)
        expect(@participant_visits.size).to eq(1)
        expect(@participant_visit.participant_id).to eq(@participant.id)
        expect(@participant_visit.visit_id).to eq(@visit.id)
        expect(@participant_visit.stipend_value).to eq("30.00")

      end
    end


    after do
      begin
      ensure
        @participant.destroy
        @arm.destroy
        @visit_schedule.destroy
        @site.destroy
        @study.destroy
      end
    end
  end
=begin
  context 'when listing participant visits' do
    @participant_visits = PASS::ParticipantVisit.list
  end

  it 'should return a list of participant visits' do
    expect(@participant_visits).to be_kind_of(Array)
    expect(@participant_visits.first).to be_kind_of(PASS::ParticipantVisit)
  end
=end
end
