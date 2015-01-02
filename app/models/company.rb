class Company < ActiveRecord::Base
  has_many :documents
  has_many :users

  #after_create :refresh_data

  # def access_token
  #   users.where{oauth_token!=nil}.first.try(:oauth_token)
  # end

  def refresh_data
    ts = Tradeshift.new access_token, ts_account_id
    Jobs::UpdateCompanyDocuments.run ts, self
  end

  def self.create_from_tradeshift_response(resp)
    existing = self.find_by_ts_account_id(resp['CompanyAccountId'])

    return existing if existing

    create!({
        name: resp['CompanyName'],
        ts_account_id: resp['CompanyAccountId']
    })
  end
end
