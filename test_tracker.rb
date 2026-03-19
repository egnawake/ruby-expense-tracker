require_relative "tracker"
require "minitest/autorun"

class TestTracker < Minitest::Test
  def test_create
    assert_empty(Tracker.new.expenses)
  end

  def test_add_expense
    t = Tracker.new
    t.add("Lunch", 20)

    refute_empty(t.expenses)

    assert_equal(1, t.expenses[0].id)
    assert_equal("Lunch", t.expenses[0].description)
    assert_equal(20, t.expenses[0].amount)
  end
end
