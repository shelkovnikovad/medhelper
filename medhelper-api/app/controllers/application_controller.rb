class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include ActionController::HttpAuthentication::Token::ControllerMethods

  helper_method :current_user
  helper_method :is_current_user_operator

  def current_user
    puts request.headers['Authorization']
    authenticate_or_request_with_http_token do |token|
      @current_user = User.find_by_token(token)
    end
  end

  def is_current_user_operator
    cur_user = current_user
    if cur_user and cur_user.role == 1
      return true
    end
    return false
  end


  def authorize
    render status: :forbidden unless current_user
  end
end
