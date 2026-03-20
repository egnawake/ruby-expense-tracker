require "csv"
require "time"
require_relative "expense"

class Tracker
  include Enumerable

  attr_reader :expenses

  def initialize(csv_path = default_csv_path)
    @expenses = []
    @csv_path = csv_path

    start_id = 1

    if File.exist?(csv_path)
      File.open(csv_path, "r") do |file|
        load_csv(file)
      end
      start_id = @expenses.map(&:id).max + 1
    end

    @id = Enumerator.produce(start_id, &:succ)
  end

  def save
    File.open(@csv_path, "w") do |file|
      write_csv(file)
    end
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

  private def load_csv(data)
    CSV.foreach(data) do |row|
      id = Integer(row[0])
      timestamp = Time.parse(row[1])
      description = row[2]
      amount = Integer(row[3])

      @expenses << Expense.new(id, timestamp, description, amount)
    end
  end

  private def write_csv(data)
    each do |expense|
      data << [expense.id, expense.timestamp, expense.description, expense.amount].to_csv
    end
  end

  private def default_csv_path
    dir = ENV["XDG_DATA_HOME"] || File.join(ENV["HOME"], ".local", "share")
    File.join(dir, "expense_data.csv")
  end
end
