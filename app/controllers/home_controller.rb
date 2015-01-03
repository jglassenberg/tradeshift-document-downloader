class HomeController < ApplicationController
  layout 'external_page'

  def landing
    render 'landing'
  end

  def login
    if current_company
      redirect_to documents_url
    else
      redirect_to tradeshift_oauth_login_url
    end
  end

  def register
    return error(401, "Bad OAuth State") unless params[:state] == session[:state]

    resp = HTTParty.post("https://api-sandbox.tradeshift.com/tradeshift/auth/token", {
      body: {
        grant_type: 'authorization_code',
        code: params[:code],
        scope: 'Tradeshift.DocumentDownloader.0.0.3'
      },
      headers: {
        "Accept" => "application/json",
        "Content-Type" => "application/x-www-form-urlencoded"
      },
      basic_auth: {
        :username => 'Tradeshift.DocumentDownloader',
        :password => 'jordanisking416'}
    })

    puts "RESP", resp.inspect
    puts "BODY", resp.body

    # render text: resp.body

    return tradeshift_error! unless resp.success?

    access_token = JSON.parse(resp.body)['access_token']

    resp = HTTParty.get("https://api-sandbox.tradeshift.com/tradeshift/rest/external/account/info", {
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer "+access_token
    }})

    # puts "access_token", access_token
    # puts "ACCOUNT RESP", resp.inspect
    # puts "ACCOUNT BODY", resp.body
    # render text: resp.body

    return tradeshift_error! unless resp.success?

    cdata = JSON.parse resp.body

    company = Company.create_from_tradeshift_response cdata
    company.access_token = access_token
    company.save!

    session['company_id'] = company.id

    if company.docs_last_updated_at.nil?
      company.refresh_data
      redirect_to documents_url, flash: {success: "Welcome! Because this is the first time you've logged in, we'll need a few minutes to index your documents. If you have a lot of documents, this can take up to 10 minutes."}
    else
      redirect_to documents_url, flash: {success: "Welcome! Here are your documents."}
    end
  end
end
