# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    company nil
    ts_doc_id "MyString"
    last_activity_at "2015-01-01 13:19:17"
    sender_name "MyString"
    receiver_name "MyString"
    type ""
    issue_date "2015-01-01 13:19:17"
    status "MyString"
    amount_before_tax "9.99"
    tax "9.99"
    currency "MyString"
  end
end
