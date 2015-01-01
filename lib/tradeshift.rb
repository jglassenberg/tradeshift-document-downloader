# This class is our interface with the TS api.

class Tradeshift
    def initialize(access_token, env='live')
        @env = 'live'
        @access_token = access_token
        # Do some auth / save the necessary tokens
        # to make auth'd requests with this instance.
    end

    # params: A CompanyAccountId for the company whose docs we want.
    # returns: A list of all the documents owned by this company.
    # notes: Get all the pages.
    def documents_list_for_company(company_account_id)

    end
end
