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
end

CLI.new.run
