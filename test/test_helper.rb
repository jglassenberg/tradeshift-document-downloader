ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "mocha/test_unit"

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...


  def expect_trigger_message(who, event_name, times=1)
    Analytics.expects(:track).times(times).with(event_name, anything)
    Analytics.expects(:identfiy).with(who, 'trigger_message_new_question', anything)
  end
end


# Runs assert_difference with a number of conditions and varying difference
# counts.
#
# Call as follows:
#
# assert_differences([['Model1.count', 2], ['Model2.count', 3]])
#
def assert_differences(expression_array, message = nil, &block)
  b = block.send(:binding)
  before = expression_array.map { |expr| eval(expr[0], b) }

  yield

  expression_array.each_with_index do |pair, i|
    e = pair[0]
    difference = pair[1]
    error = "#{e.inspect} didn't change by #{difference}"
    error = "#{message}\n#{error}" if message
    assert_equal(before[i] + difference, eval(e, b), error)
  end
end
