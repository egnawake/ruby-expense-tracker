require "optparse"
require_relative "tracker"

class CLI
  def run
    @tracker = Tracker.new

    command = ARGV.shift
    send(command)
  end

  private def add
    description = nil
    amount = nil

    parser = OptionParser.new
    parser.on("-d", "--description DESC") do |value|
      description = value
    end
    parser.on("-a", "--amount AMNT", Integer) do |value|
      amount = value
    end
    parser.parse!

    @tracker.add(description, amount)
    @tracker.save
  end

  private def list
    @tracker.each do |expense|
      puts expense
    end
  end

  private def update
    description = nil
    amount = nil
    id = nil

    parser = OptionParser.new
    parser.on("-d", "--description DESC") do |value|
      description = value
    end
    parser.on("-a", "--amount AMNT", Integer) do |value|
      amount = value
    end
    parser.on("--id ID", Integer) do |value|
      id = value
    end

    parser.parse!

    unless id
      STDERR.puts "Expense ID missing"
      return
    end

    @tracker.update(id, description:, amount:)
    @tracker.save
  end

  private def delete
    id = nil

    parser = OptionParser.new
    parser.on("--id ID", Integer) do |value|
      id = value
    end
    parser.parse!

    unless id
      STDERR.puts "Expense ID missing"
      return
    end

    @tracker.delete(id)
    @tracker.save
  end

  private def summary
    month = nil

    parser = OptionParser.new
    parser.on("--month MM", Integer) do |value|
      month = value
    end

    parser.parse!

    total =
      if month
        @tracker
          .filter { |e| month == e.timestamp.month }
          .map { |e| e.amount }
          .sum
      else
        @tracker.map { |e| e.amount }.sum
      end

    puts "#{total}€"
  end
end

CLI.new.run
