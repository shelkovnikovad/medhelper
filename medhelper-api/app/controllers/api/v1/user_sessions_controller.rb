class Api::V1::UserSessionsController < ApplicationController
  def create
    ApplicationRecord
    user = User.find_by_name(params[:name])
    if user && user.authenticate(params[:password])

      user.update_attributes!(:token => SecureRandom.base64(15).tr('+/=', '0aZ'))
      @session_token = {token: user.token, operator: user.role == 1}
      render json: @session_token, status: :accepted
    else
      render json: nil, status: :forbidden
    end
  end
end
