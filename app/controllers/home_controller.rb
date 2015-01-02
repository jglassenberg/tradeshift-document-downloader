class HomeController < ApplicationController
  layout 'external_page'

  def landing
    render 'landing'
  end
end
