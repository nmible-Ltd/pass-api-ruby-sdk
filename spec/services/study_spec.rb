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

  context 'with valid study attributes and creating a study' do
    before do
      @attributes = StudyFixture.valid
      @study = PASS::Study.new
      @study.assign_attributes(@attributes)
      @study.save
    end

    it 'should create a study' do
      expect(@study.valid?).to be true
      expect(@study.id).to be_present
    end

    context "when listing studies with a filter" do
      before do
        @studies = PASS::Study.list(filters: {protocolNumber: @attributes[:protocol_number]})
      end

      it 'should return a list of 1 study' do
        expect(@studies).to be_kind_of(Array)
        expect(@studies.first).to be_kind_of(PASS::Study)
        expect(@studies.size).to eq(1)
        expect(@studies.first.protocol_number).to eq(@attributes[:protocol_number])
      end
    end

    context "when attempting to get a study" do
      before do
        @actual = PASS::Study.get(@study.id)
        expect(@actual.id).to eq(@study.id)
        expect(@actual.protocol_number).to eq(@study.protocol_number)
      end
    end

    after do
      @study.destroy
    end

  end

end
