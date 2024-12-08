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

=begin
  context 'when listing visits with a filter of name and an arm attached' do
    before do
      @name = 'Visit 1'
      pp PASS::Visit.list
      @participant = PASS::Participant.list(filters: {client_id: 'arm-2-no-randomisation'}).first
      puts @participant.arm_id
      puts PASS::Participant.list.map { |x| [x.client_id, x.arm_id]}.inspect
      @visits = PASS::Visit.list(filters: {arm_id: @participant.arm_id})
      puts @visits.inspect
    end

    it 'should return a list of visits of size 1 with the right name' do
      expect(@visits).to be_kind_of(Array)
      expect(@visits.size).to eq(1)
      expect(@visits.first).to be_kind_of(PASS::Visit)
      expect(@visits.first.name).to eq(@name)
    end
  end
=end
end
