class Company < ActiveRecord::Base
  has_many :documents
  has_many :users
end
