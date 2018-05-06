class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  def current_token
    if session[:token]
      true
    else
      false
    end
  end

  helper_method :current_token
  helper_method :get_current_user_name
  helper_method :can_user_modify_task

  def get_current_user_name
    if current_token
      return session[:user_name]
    else
      return 'No auth'
    end
  end

  def check_authorize
    redirect_to :controller => 'tasks', :action => 'index' if current_token
  end

  def authorize
    redirect_to :controller => 'welcome', :action => 'index' if not current_token
  end

  def  can_user_modify_task
    return 1 == session[:role]
  end

  def can_user_complete_task
    return false == can_user_modify_task
  end

  def sign_out_session
    session.clear
  end

  def get_client_api
    client = Faraday.new(url: 'http://localhost:3000') do |config|
      config.adapter  Faraday.default_adapter
      config.token_auth("#{session[:token]}") if current_token
    end
    return client
  end
end
