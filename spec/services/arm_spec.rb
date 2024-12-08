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
end
