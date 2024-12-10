module PASS
  class ExpenseType < PASS::Resource
    attribute :name, :string
    attribute :created_at, :time
    attribute :updated_at, :time
    attribute :deleted_at, :time

    attr_accessor :id

    class << self
      def list_endpoint
        'expense-types'
      end
    end

  end
end
