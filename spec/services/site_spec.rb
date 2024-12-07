RSpec.describe 'PASS::Site' do
  context 'when listing sites' do
    before do
      @sites = PASS::Site.list
    end

    it 'should return a list of sites' do
      expect(@sites).to be_kind_of(Array)
      expect(@sites.first).to be_kind_of(PASS::Site)
      expect(@sites.first.name).to be_kind_of(String)
    end
  end

  context 'when listing sites with a filter of study' do
    before do
      @study = PASS::Study.list.first
      @sites = PASS::Site.list(filters: {study: @study.id})
    end


    it 'should return a list of sites associated to a study' do
      expect(@sites).to be_kind_of(Array)
      expect(@sites.first).to be_kind_of(PASS::Site)
      expect(@sites.first.study_id).to eq(@study.id)
    end
  end
end
