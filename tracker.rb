require "csv"
require "time"
require_relative "expense"

class Tracker
  include Enumerable

  attr_reader :expenses

  def initialize
    @expenses = []
    @id = create_id(1)
  end

  def load(io)
    @expenses = load_csv(io)
    max_id = @expenses.empty? ? 1 : @expenses.map(&:id).max
    @id = create_id(max_id)
  end

  def save(io)
    write_csv(io)
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

  private def create_id(start) = Enumerator.produce(start, &:succ)

  private def load_csv(io)
    data = []
    CSV.foreach(io) do |row|
      id = Integer(row[0])
      timestamp = Time.parse(row[1])
      description = row[2]
      amount = Integer(row[3])

      data << Expense.new(id, timestamp, description, amount)
    end
    data
  end

  private def write_csv(io)
    each do |expense|
      io << [expense.id, expense.timestamp, expense.description, expense.amount].to_csv
    end
  end
end
