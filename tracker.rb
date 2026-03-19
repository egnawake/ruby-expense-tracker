require_relative "expense"

class Tracker
  attr_reader :expenses

  def initialize
    @expenses = []
    @id = Enumerator.produce(1, &:succ)
  end

  def add(description, amount)
    @expenses << Expense.new(@id.next, Time.now, description, amount)
  end
end
