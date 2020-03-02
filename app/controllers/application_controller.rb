class ApplicationController < ActionController::Base
  helper_method %i[current_user signed_in?]

  private

  def signin(user)
    session[:user_id] = user.id
  end

  def signout
    reset_session
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !current_user.nil?
  end
end
