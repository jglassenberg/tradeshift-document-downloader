require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
    test "parses a received document response" do
        company = FactoryGirl.create :company
        document = Document.create_from_company_and_response company, rec_doc_resp
    end

    test "parses a sent document response" do
        company = FactoryGirl.create :company
        document = Document.create_from_company_and_response company, sent_doc_resp
    end
end


