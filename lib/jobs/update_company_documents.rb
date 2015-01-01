class Jobs::UpdateCompanyDocuments
    class << self
        def run(ts, company)
            live_docs = ts.documents_list_for_company(company.ts_account_id)

            # Update documents with new data
            live_docs.each do |doc|
                # Find the cached document
                match = company.documents.where{id==my{doc['id']}}

                # Cache the document if missed.
                match ||= Document.create_from_company_and_response(company, doc)

                match.update_from_response(doc)
            end

            # Remove documents that no longer exist
            live_ids = live_docs.map{|doc| doc['DocumentId']}
            company.documents.where{ts_doc_id << my{live_ids}}.each{|doc| doc.destroy }

            company.docs_last_updated_at = Time.now
            company.save!
        end

        handle_asynchronously :run
    end
end
