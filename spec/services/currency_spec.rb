RSpec.describe 'PASS::Currency' do
  context 'when listing currencies' do
    before do
      @currencies = PASS::Currency.list
    end

    it 'should return a list of currencies' do
      expect(@currencies).to be_kind_of(Array)
      expect(@currencies.first).to be_kind_of(PASS::Currency)
      expect(@currencies.first.name).to be_kind_of(String)
    end
  end

  context 'when finding currency by ISO code USD' do
    before do
      @currency = PASS::Currency.list(filters: {code: 'USD'}).first
    end

    it 'should return United States Dollars' do
      expect(@currency).to be_kind_of(PASS::Currency)
      expect(@currency.name).to eq('United States Dollar')
      expect(@currency.symbol).to eq('$')
    end
  end
end
