class DocumentsController < ApplicationController
  before_filter :ensure_company

  def index
    @documents = current_company.documents

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
