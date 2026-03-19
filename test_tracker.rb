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

  def test_find_expense
    t = Tracker.new
    t.add("Tickets", 100)

    refute_nil(t.at_id(1))
    assert_nil(t.at_id(34))
  end

  def test_update_expense
    t = Tracker.new
    t.add("Dinner", 25)
    t.add("Switch 2", 400)

    t.update(1, amount: 30)
    dinner = t.at_id(1)
    assert_equal(30, dinner.amount)

    t.update(2, description: "PS5")
    console = t.at_id(2)
    assert_equal("PS5", console.description)
  end
end
