class Document < ActiveRecord::Base
    belongs_to :company
    self.inheritance_column = nil

    def total
       amount_before_tax - tax
    end

    def self.create_from_company_and_response(company, resp)
        if resp['SenderCompanyName']
            sent_or_received = 'received'
            sender_name = resp['SenderCompanyName']
            receiver_name = company.name
        else
            sent_or_received = 'sent'
            sender_name = company.name
            receiver_name = resp['ReceiverCompanyName']
        end

        create!({
            company_id: company.id,
            sent_or_received: sent_or_received,
            ts_doc_id:  resp['DocumentId'],
            last_activity_at: Time.parse(resp['LatestDispatch']['Created']),
            sender_name: sender_name,
            receiver_name: receiver_name,
            type: resp['DocumentType']['type'],
            issue_date: DocumentHelper.item_info_value(resp, 'document.issuedate'){|v| Time.parse(v) },
            #status: resp['UnifiedState'],
            amount_before_tax: DocumentHelper.item_info_value(resp, 'document.total'),
            currency: DocumentHelper.item_info_value(resp, 'document.currency')
        })
    end

    def update_from_response(resp)
        live_latest = Time.parse(resp['LatestDispatch']['Created'])

        update_attributes!({
            last_activity_at: live_latest,
            amount_before_tax: DocumentHelper.item_info_value(resp, 'document.total'),
            currency: DocumentHelper.item_info_value(resp, 'document.currency')
        }) if live_latest > last_activity_at
    end
end
