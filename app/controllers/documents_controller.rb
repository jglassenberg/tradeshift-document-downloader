class DocumentsController < ApplicationController
  before_filter :ensure_company

  def index
    cond = params[:q]
    cond ||= {}
    cond[:company_id_eq] = current_company.id

    @q = Document.search(cond)
    @documents = @q.result

    respond_to do |format|
      format.html {}
      format.csv  { render csv_download }
    end
  end

  private
  def csv_download
    {
        csv: @documents,
        only: Settings.documents.public_columns,
        filename: "documents_#{Time.now}.csv"
    }
  end

  def ensure_company
    return redirect_to(login_url, flash: {error: "Login first, please!"}) unless current_company
  end
end
