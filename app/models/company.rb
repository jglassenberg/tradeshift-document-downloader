class Company < ActiveRecord::Base
  has_many :documents
  has_many :users

  #after_create :refresh_data

  def access_token
    users.where{oauth_token!=nil}.first.try(:oauth_token)
  end

  def refresh_data
    ts = Tradeshift.new access_token
    Jobs::UpdateCompanyDocuments.run ts, self
  end
end
