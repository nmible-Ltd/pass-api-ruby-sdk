module PASS
  class ExpenseType < PASS::Resource
    attribute :name, :string
    attribute :created_at, :time
    attribute :updated_at, :time
    attribute :deleted_at, :time

    attr_accessor :id

    class << self
      def list(filters: {})
        response = PASS::Client.instance.connection.get 'expense-types'
        filtered_objects_from_response(response, filters)
      end
    end

  end
end
