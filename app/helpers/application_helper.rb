module ApplicationHelper
    def current_company
        if session[:company_id]
            Company.find(session[:company_id])
        end
    end

    def tradeshift_error!
        # TODO Airbrake
        return redirect_to root_url, flash: {warning: "Trouble connecting to Tradeshift!"}
    end

    def tradeshift_oauth_login_url
        session[:state] = (0...15).map { (65 + rand(26)).chr }.join

        "https://api-sandbox.tradeshift.com/tradeshift/auth/login?" + {
            response_type: 'code',
            client_id: 'Tradeshift.DocumentDownloader',
            redirect_uri: ENV['REDIRECT_URL'],
            scope: 'openid offline',
            state: session[:state]
        }.to_query
    end
end
