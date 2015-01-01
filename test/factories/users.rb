# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    company nil
    ts_acount_id "MyString"
    name "MyString"
    email "MyString"
    last_login_at "2015-01-01 13:24:20"
    oauth_token "MyString"
    oauth_secret "MyString"
  end
end
