namespace :data do

  desc "Update document data from the TS api."
  task "update-docs" => :environment do
    Company.where{docs_last_updated_at > 1.hour.ago}.each do |company|
        ts = Tradeshift.new(company.access_token)
        Jobs::UpdateCompanyDocuments.run ts, company
    end
  end

end
