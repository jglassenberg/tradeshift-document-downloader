# This class is our interface with the TS api.

class Tradeshift

    def initialize(access_token, company_account_id, env='live')
        @env = 'live'
        @access_token = access_token
        @tenant_id    = company_account_id
        puts "tenant1"
        puts "#{@tenant_id}"
        puts "token1"
        puts "#{@access_token}"
        # Do some auth / save the necessary tokens
        # to make auth'd requests with this instance.
    end

    # params: A CompanyAccountId for the company whose docs we want.
    # returns: A list of all the documents owned by this company.
    # notes: Get all the pages.
    def documents_list_for_company()

		#puts "Tenant id:"
		#puts "#{@tenant_id}"
		puts "token"
		puts "#{@access_token}"

        # call API to find out how many docs are in the list
        response = HTTParty.get(
        	"#{ENV['API_HOST_URL']}/tradeshift/rest/external/documents/",
        	headers: {
    	    		'X-Tradeshift-TenantId' => @tenant_id,
    	    		'Accept' => 'application/json',
    	    		'User-Agent' => 'TradeshiftDocumentsDownload/0.1',
    	    		'Authorization' => "Bearer #{@access_token}"
    	    	}
        )
       # puts "#{response}"
       ### TODO: this line is causing the next error
        parsed = JSON.parse(response.body)
	#puts "#{parsed}"
        #Store all of the documents in an array.  It will be an array of pages, 25 items long.
        #results = Array.new()
        #results.push(parsed["Document"])
        results = parsed["Document"]
	#puts "#{results}"
        #get the length of the app
        numpages = parsed["numPages"]

        puts "GOT SOME DOCS. GETTING #{numpages} more pages"

        #We can change this easily, but keep the items per page to 25 for now (the default)
        itemsperpage = 25

        # loop through until you have all content.  If there was only one page, this doesn't execute.
        (numpages - 1).times do |i|
            puts "Extra page #{i}"
    	    #Call API with the page #i
    	    #TODO: this call may require filters based on the customer's specifications
    	    response = HTTParty.get(
    	    	"#{ENV['API_HOST_URL']}/tradeshift/rest/external/documents/?page=#{i}&limit=#{itemsperpage}",
    	    	headers: {
    	    		'X-Tradeshift-TenantId' => @tenant_id,
    	    		'Accept' => 'application/json',
    	    		'User-Agent' => 'TradeshiftDocumentsDownload/0.1',
    	    		'Authorization' => "Bearer #{@access_token}"
    	    	}
    	    )

            parsed = JSON.parse(response)
	        results += parsed["Document"]
        end

        #How to obtain data:
        # Document ID: results[item_number]["ID"]
        # Document type: results[item_number]["DocumentType"]["type"]
        # Document status: results[item_number]["State"]
        # Sent or received - whether "SenderCompanyName" or "ReceiverCompanyName" exists.
        # Sender full name (for received documents): results[item_number]["SenderCompanyName"]
        # Receiver full name (for documents you sent): results[item_number]["ReceiverCompanyName"]
        # Issue date: results[item_number]["ItemInfos"][ItemInfos_number] - where .type = "document.issuedate"
        # Amount: results[item_number]["ItemInfos"][ItemInfos_number] - where .type = "document.total"
        # Currency: results[item_number]["ItemInfos"][ItemInfos_number] - where .type = "document.currency"

        puts "SHITYEA", results

        return results
    end
end
