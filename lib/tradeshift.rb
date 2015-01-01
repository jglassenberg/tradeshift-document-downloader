# This class is our interface with the TS api.

class Tradeshift
    include HTTParty

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

        # call API to find out how many docs are in the list
        #TODO: add parameters to coincide with selected filters
        response = HTTParty.get(
        	'https://api.tradeshift.com/tradeshift/rest/external/documents/', 
        	headers: {
    	    		'X-Tradeshift-TenantId' => company_account_id,
    	    		'Accept' => 'application/json',
    	    		'User-Agent' => 'TradeshiftDocumentsDownload/0.1',
    	    		'Authorization' => "Bearer #@accessToken"
    	    	}
        )
        parsed = JSON.parse(response)

        #Store all of the documents in an array.  It will be an array of pages, 25 items long.
        results = Array.new()
        results.push(parsed["Document"])

        #get the length of the app
        numpages = parsed["numPages"]

        #We can change this easily, but keep the items per page to 25 for now (the default)
        itemsperpage = 25 

        # loop through until you have all content.  If there was only one page, this doesn't execute.
        (numPages - 1).times do |i|
	    #Call API with the page #i
	    #TODO: this call may require filters based on the customer's specifications
    	    response = HTTParty.get(
    	    	"https://api.tradeshift.com/tradeshift/rest/external/documents/?page=#{i}&limit=#{itemsperpage}", 
    	    	headers: {
    	    		'X-Tradeshift-TenantId' => company_account_id,
    	    		'Accept' => 'application/json',
    	    		'User-Agent' => 'TradeshiftDocumentsDownload/0.1',
    	    		'Authorization' => "Bearer #@accessToken"
    	    	}
    	    )

	    parsed = JSON.parse(response)
	    results.push(parsed["Document"])
        end
        return results
    end
end
