RSpec.describe 'PASS::Participant' do
  context 'when listing participants' do
    before do
      @participants = PASS::Participant.list
    end

    it 'should return a list of participants' do
      expect(@participants).to be_kind_of(Array)
      expect(@participants.first).to be_kind_of(PASS::Participant)
      expect(@participants.first.year_of_birth).to be_kind_of(String)
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
