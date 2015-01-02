class DocumentsController < ApplicationController

  def index
    @documents = current_user.company.documents
  end

  private
end
