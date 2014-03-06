class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def error(status, code, message)
    render :json => {:response_type => "ERROR", :response_code => code, :message => message}, :status => status
  end

  # Redirect the user to their game, if they have an active one.
  def one_game_at_a_time
    return redirect_to current_user.current_game if current_user.has_active_game?
  end
end
