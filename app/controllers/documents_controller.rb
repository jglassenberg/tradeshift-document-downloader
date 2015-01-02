class DocumentsController < ApplicationController
  before_filter :ensure_company

  def index
    @documents = User.first.company.documents
  end

  private
  def ensure_company
    return redirect_to(login_url, flash: {warning: "Login first, please!"}) unless current_company
  end
end
