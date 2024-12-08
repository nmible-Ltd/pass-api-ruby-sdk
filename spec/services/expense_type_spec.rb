RSpec.describe 'PASS::ExpenseType' do
  context 'when listing expense types' do
    before do
      @expense_types = PASS::ExpenseType.list
    end

    it 'should return a list of expense types' do
      expect(@expense_types).to be_kind_of(Array)
      expect(@expense_types.first).to be_kind_of(PASS::ExpenseType)
      expect(@expense_types.first.name).to be_kind_of(String)
    end
  end

  context 'when finding expense type by name' do
    before do
      @expense_type = PASS::ExpenseType.list(filters: {name: 'Mileage'}).first
    end

    it 'should return Mileage' do
      expect(@expense_type).to be_kind_of(PASS::ExpenseType)
      expect(@expense_type.name).to eq('Mileage')
    end
  end
end
