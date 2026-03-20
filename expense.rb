class Expense
  attr_reader(
    :id, :timestamp, :description, :amount
  )

  def initialize(id, timestamp, description, amount)
    @id = id
    @timestamp = timestamp
    @description = description
    @amount = amount
  end

  def to_s
    "(#{id} | #{timestamp.strftime("%d/%m/%Y")}) #{description} - #{amount}€"
  end
end
