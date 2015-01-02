class DownloadMailer < ActionMailer::Base
  default from: "support@tradeshift.com"

  def files_done(user, data)
    csv_string = CSV.generate do |csv|
      data.each{|row| csv << row }
    end

    attachments['export.csv'] = {
      :data => ActiveSupport::Base64.encode64(csv_string),
      :encoding => 'base64'
    }

    mail(
        :body => "Your requested export is attached. Thank you for using Tradeshift.",
        :to => user.email,
        :subject => "Your recent document export from Tradeshift"
    )
  end
end
