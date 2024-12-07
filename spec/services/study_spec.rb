RSpec.describe 'PASS::Study' do
  context 'when listing studies' do
    before do
      @studies = PASS::Study.list
    end

    it 'should return a list of studies' do
      expect(@studies).to be_kind_of(Array)
      expect(@studies.first).to be_kind_of(PASS::Study)
      expect(@studies.first.name).to be_kind_of(String)
    end
  end

  context 'when listing studies with a filter' do
    before do
      @studies = PASS::Study.list(filters: {protocol_number: '101010'})
    end

    it 'should return a list of 1 study' do
      expect(@studies).to be_kind_of(Array)
      expect(@studies.first).to be_kind_of(PASS::Study)
      expect(@studies.size).to eq(1)
      expect(@studies.first.protocol_number).to eq('101010')
    end
  end
end
