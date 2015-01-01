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

  def sent_doc_resp
    {"DocumentId"=>"697aa547-bead-4bab-a42c-3f5b5a4ed75d", "ID"=>"115436547", "URI"=>"https://api.tradeshift.com/tradeshift/rest/external/documents/697aa547-bead-4bab-a42c-3f5b5a4ed75d", "DocumentType"=>{"mimeType"=>"text/xml", "documentProfileId"=>"ubl.invoice.2.1.us", "type"=>"invoice"}, "State"=>"LOCKED", "LastEdit"=>"2014-03-06T23:14:30.934Z", "ReceiverCompanyName"=>"Vik Chawla", "Tags"=>{"Tag"=>[]}, "ItemInfos"=>[{"type"=>"document.description", "value"=>"vodka"}, {"type"=>"document.total", "value"=>"10.22"}, {"type"=>"document.currency", "value"=>"USD"}, {"type"=>"document.issuedate", "value"=>"2014-03-06"}, {"type"=>"invoice.due", "value"=>"2014-03-06"}], "LatestDispatch"=>{"DispatchId"=>"45665f35-f32e-44f1-9d05-0c0f6b4bdce1", "ObjectId"=>"697aa547-bead-4bab-a42c-3f5b5a4ed75d", "Created"=>"2014-03-07T00:02:16.676Z", "SenderUserId"=>"51f153f1-9b3c-4b27-ac25-bc633fc0c003", "DispatchState"=>"COMPLETED", "LastStateChange"=>"2014-03-07T00:02:16.676Z", "DispatchChannel"=>"async"}, "SentReceivedTimestamp"=>"2014-03-07T00:01:07.410Z", "ProcessState"=>"OVERDUE", "ConversationStates"=>[{"Axis"=>"PROCESS", "State"=>"OVERDUE", "Timestamp"=>"2014-03-07T00:02:16.195Z"}, {"Axis"=>"OTHERPART", "State"=>"OTHER_ACCEPTED", "Timestamp"=>"2014-03-06T23:21:09.463Z"}, {"Axis"=>"DELIVERY", "State"=>"SENT", "Timestamp"=>"2014-03-06T23:14:36.875Z"}], "UnifiedState"=>"OVERDUE", "Properties"=>[{"scheme"=>"emailBody", "value"=>""}, {"scheme"=>"emailSubject", "value"=>""}]}
  end

  def rec_doc_resp
     {"DocumentId"=>"d844dd32-ace1-5ccd-a323-2757dc955e9f", "ID"=>"Test456", "URI"=>"https://api.tradeshift.com/tradeshift/rest/external/documents/d844dd32-ace1-5ccd-a323-2757dc955e9f", "DocumentType"=>{"mimeType"=>"text/xml", "documentProfileId"=>"ubl.invoice.2.1.us", "type"=>"invoice"}, "State"=>"LOCKED", "LastEdit"=>"2015-01-01T21:38:41.805Z", "SenderCompanyName"=>"Jeremy Tester", "ReceivedToCompanyAccountId"=>"94d93633-0b14-406b-86f0-2c2ac4993857", "Tags"=>{"Tag"=>[]}, "ItemInfos"=>[{"type"=>"document.description", "value"=>"testing testing testing"}, {"type"=>"document.total", "value"=>"21.52"}, {"type"=>"document.currency", "value"=>"USD"}, {"type"=>"document.issuedate", "value"=>"2015-01-01"}, {"type"=>"invoice.due", "value"=>"2015-01-30"}], "LatestDispatch"=>{"DispatchId"=>"6174a4ee-d701-44a5-8006-966c407cfe84", "ObjectId"=>"d844dd32-ace1-5ccd-a323-2757dc955e9f", "Created"=>"2015-01-01T21:38:44.242Z", "SenderUserId"=>"51f153f1-9b3c-4b27-ac25-bc633fc0c003", "DispatchState"=>"COMPLETED", "LastStateChange"=>"2015-01-01T21:38:44.242Z"}, "SentReceivedTimestamp"=>"2015-01-01T21:38:41.805Z", "ProcessState"=>"PENDING", "ConversationStates"=>[{"Axis"=>"PROCESS", "State"=>"PENDING", "Timestamp"=>"2015-01-01T21:38:41.805Z"}, {"Axis"=>"OTHERPART", "State"=>"OTHER_PENDING", "Timestamp"=>"2015-01-01T21:38:44.837Z"}, {"Axis"=>"DELIVERY", "State"=>"RECEIVED", "Timestamp"=>"2015-01-01T21:38:41.805Z"}], "UnifiedState"=>"DELIVERED", "Properties"=>[]}
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
