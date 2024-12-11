RSpec.describe 'PASS::Micropayment' do
  context 'with valid dependencies' do
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
    end

    context 'with valid micropayment information' do
      before do
        @attributes = {
          label: 'DAY1',
          amount: '120.21',
          participant_id: @participant.id
        }
        @micropayment = PASS::Micropayment.new
        @micropayment.assign_attributes(@attributes)
        @micropayment.save
      end

      it 'should be able to create a micropayment' do
        expect(@micropayment.valid?)
        expect(@micropayment.id.present?)
        expect(@micropayment.participant_id).to eq(@participant.id)
      end

      after do
        @micropayment.destroy
      end

      context 'when listing micropayments with a filter of participant_id' do
        before do
          @micropayments = PASS::Micropayment.list(filters: {participant_id: @participant.id})
        end

        it 'should be able to bring up a list of one micropayment with label of DAY1' do
          expect(@micropayments).to be_kind_of(Array)
          expect(@micropayments.size).to eq(1)
          expect(@micropayments.first).to be_kind_of(PASS::Micropayment)
          expect(@micropayments.first.label).to eq('DAY1')
        end

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
end
