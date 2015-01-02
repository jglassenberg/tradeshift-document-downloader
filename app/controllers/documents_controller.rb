class DocumentsController < ApplicationController

  def index
    @documents = User.first.company.documents
  end

  private
end
