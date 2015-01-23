    ###############################################################
    ## Additional functions to support the analytics project.  
    ## These are not well tested!!!
    #############################################################
    
    ## Returns the total number of invoices transacted.  
    #TODO: add filters such as time span.
    def total_invoices_transacted (documents)
    	total = 0
    	
    	
    	documents.each 
    	{  |i|
    		
    		## TODO: take currency into consideration
    		i["itemInfos"].each
    		{ |j|
    			if i["itemInfos"][j]["type"] = "document.total"  #may be i["itemInfos"][j].type
    				total += i["itemInfos"][n]["value"]  #may be i["itemInfos"][j].value
    			end
    			
    		}
    		
    	}
    	
    	return total
    end
    
    ## Returns the average number of invoices received per day
    #TODO: add filters such as timespan
    def invoices_per_day (documents)
    
    	#Assume that document is sorted and filtered to invoices
    	invoice_quantity = documents.length
    	start_date = documents[0]["SentReceivedTimestamp"] #Not sure if that attribute provides what we really need
    	
    	end_date = documents[invoice_quantity-1]["SentReceivedTimestamp"]
    	
    	#convert from timestamp to numeric. Not sure if parse is working
    	
    	start_t = Time.parse(start_date)
    	
    	end_t = Time.parse(end_date)
    	
    	span = Time.diff(end_t, start_t)
    	
    	# This doesn't take leap years or or month lengths into account. Should be replaced. 
    	
    	##Note: just take days in UTC and subtract.
    	
    	days = span["year"]*365 + span["month"] * 30 + span["week"] * 7 + span["days"]
    	
    	return invoice_quantity / days
    
    end
    
    
    #Obtain the customer's network of suppliers and filter them elsewhere
    def suppliers_list ()
    
    	#results = Array.new
    
    	response = HTTParty.get(
        	"#{ENV['API_HOST_URL']}/tradeshift/rest/external/connections/network",
        	headers: {
    	    		'X-Tradeshift-TenantId' => @tenant_id,
    	    		'Accept' => 'application/json',
    	    		'User-Agent' => 'TradeshiftDocumentsDownload/0.1',
    	    		'Authorization' => "Bearer #{@access_token}"
    	    	}
        )
        
        parsed = JSON.parse(response.body)
        
        connections = parsed["Connection"]
        
        
        
        #filter section
        connections.each
        { |i|
        
        	# We may want to filter the content, separating external connections from Tradeshift connections
        
        }
        
        return connections
    
    end
    
   
    
    ## Obtains list of suppliers who sent invoices
    ## Returns a list of suppliers and the number of invoices sent by each.
    
    def suppliers_sent_invoices(documents)
    	
    	supplier_invoice_count = Array.new
    	
    	
    	documents.each 
    	{  |i|
    		
    		# Find the sender of each document
    		## TODO: This may return a userID rather than a tenant ID, causing us to count more unique suppliers
    		sender_id = i["LatestDispatch"]["SenderUserId"]
    		
    		# Add a new supplier to the list, or increment the invoice count for a supplier we already identified
    		if (supper_invoice_count.index(sender_id))
    			supplier_invoice_count[sender_id] += 1
    			
    		else
    			
    			supplier_invoice_count[sender_id] = 1
    		end
    		
    	}
    	
    	return supplier_invoice_count
    	
    	
    end
    
    ## Returns the percentage of suppliers connected to the user who have sent an invoice
    def supplier_sent_invoices_percent (suppliers, document)
    	return suppliers_sent_invoices(documents).length / suppliers.length
    
    end
    
    ## Obtain list of supplier activations
    
    #external/network/connections: the total number of connections vs the total number of connections with “ConnectionType” of “TradeshiftConnection” (todo: confirm this is accurate)
    
    def supplier_activations_total (suppliers)
    	
    	## We think we can get by from counting external connections and Tradeshift connections
    	
    	total = 0
    	
    	 #filter section
        suppliers.each
        { |i|
        
        	if (i["ConnectionType"] == "TradeshiftConnection")
        	
        		total += 1
        	end
        
        }
        
        return total
    	
    end
    
     def supplier_activations_percent (suppliers)
    	
    	## We think we can get by from counting external connections and Tradeshift connections
    	
    	return supplier_activations_total(suppliers)/suppliers.length
    	
    end
    
    # Obtain the number of suppliers who've activated over a given period of time
    ##TODO: this information may not be available in the API today. Or we may rely on campaigns
    def supplier_activations_time (suppliers, start, end)
    
    
    
    end
    
    ## Delete documents given their doc IDs
    def delete_docs (ids)
    	ids.each { |i|
   			 response = HTTParty.delete(
         	 "#{ENV['API_HOST_URL']}/tradeshift/rest/external/documents/#{@i}",
        	 headers: {
    	    		'X-Tradeshift-TenantId' => @tenant_id,
    	    		'Accept' => 'application/json',
    	    		'User-Agent' => 'TradeshiftDocumentsDownload/0.1',
    	    		'Authorization' => "Bearer #{@access_token}"
    	    	}
        	)
        	
        	parsed = JSON.parse(response.body)
        	
        	##TODO: store output of API method here.
        	
        	## TODO: add error handling
        }
                
        
    
    end
    
end
