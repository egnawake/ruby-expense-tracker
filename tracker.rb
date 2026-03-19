require_relative "expense"

class Tracker
  include Enumerable

  attr_reader :expenses

  def initialize
    @expenses = []
    @id = Enumerator.produce(1, &:succ)
  end

  def at_id(id)
    @expenses.find { |e| id == e.id }
  end

  def add(description, amount)
    @expenses << Expense.new(@id.next, Time.now, description, amount)
  end

  def update(id, description: nil, amount: nil)
    @expenses = @expenses.map do |e|
      if id == e.id
        Expense.new(e.id, e.timestamp,
          description || e.description,
          amount || e.amount
        )
      else
        e
      end
    end
  end

  def delete(id)
    @expenses = @expenses.filter { |e| id != e.id }
  end

  def each(&) = expenses.each(&)
end
