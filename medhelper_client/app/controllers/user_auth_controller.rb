class UserAuthController < ApplicationController
  before_action :check_authorize, only: [:create, :new]
  def new

  end

    def create
      puts user_name = params[:name]
      puts pwd = params[:password]
      if user_name && pwd
        client = Faraday.new(url: 'http://localhost:3000') do |config|
          config.adapter  Faraday.default_adapter
        end

        response = client.post do |req|
          puts
          req.url '/signin'
          req.headers['Content-Type'] = 'application/json'
          req.body = "{\"name\": \"#{user_name}\", \"password\": \"#{pwd}\"}"
        end

        obj = Oj.load(response.body, {:mode => :object })
        if response.status == 202
          token = obj["token"]
          if token
            session[:token] = token
            session[:role] = obj["role"]
            session[:user_name] = user_name
            redirect_to :controller => 'tasks', :action => 'index'
          end
          puts "ALL Ok"
        else
          if response.status == 403

          flash[:error] = "Wrong name and password"
          render 'new'
          end
        end
      else

      end
    end

  def new

  end

  def index

  end

  def sign_out
    sign_out_session
    redirect_to root_url
  end
end
