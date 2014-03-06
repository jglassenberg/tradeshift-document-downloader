FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  to_create do |i|
    without_callbacks do
      i.save!
    end
    i
  end
end