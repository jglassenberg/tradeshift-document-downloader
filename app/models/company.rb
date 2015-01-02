class Company < ActiveRecord::Base
  has_many :documents
  has_many :users

  def access_token
    token = users.where{oauth_token!=nil}.first.try(:oauth_token)

    raise "Company has no access token!" in token.nil?

    token
  end
end
