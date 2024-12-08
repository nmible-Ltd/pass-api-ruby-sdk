RSpec.describe 'PASS::Language' do
  context 'when listing languages' do
    before do
      @languages = PASS::Language.list
    end

    it 'should return a list of languages' do
      expect(@languages).to be_kind_of(Array)
      expect(@languages.first).to be_kind_of(PASS::Language)
      expect(@languages.first.name).to be_kind_of(String)
    end
  end

  context 'when finding language by ISO code EN' do
    before do
      @language = PASS::Language.list(filters: {code: 'EN'}).first
    end

    it 'should return English' do
      expect(@language).to be_kind_of(PASS::Language)
      expect(@language.name).to eq('English')
    end
  end
end
