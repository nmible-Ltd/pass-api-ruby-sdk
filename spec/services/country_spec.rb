RSpec.describe 'PASS::Country' do
  context 'when listing countries' do
    before do
      @countries = PASS::Country.list
    end

    it 'should return a list of countries' do
      expect(@countries).to be_kind_of(Array)
      expect(@countries.first).to be_kind_of(PASS::Country)
      expect(@countries.first.name).to be_kind_of(String)
    end
  end

  context 'when finding country by country code US' do
    before do
      @country = PASS::Country.list(filters: {code: 'US'}).first
    end

    it 'should return the United States' do
      expect(@country).to be_kind_of(PASS::Country)
      expect(@country.name).to eq('United States')
    end
  end
end
