class RegistrationUserController < ApplicationController

  def create
    puts user_name = params[:name]
    puts pwd = params[:password]
    puts pwd_conf = params[:password_confirmation]
    puts dispather_code = params[:dispather_code]

    if user_name && pwd && pwd_conf
      client = Faraday.new(url: 'http://localhost:3000') do |config|
        config.adapter  Faraday.default_adapter
      end

      response = client.post do |req|
        req.url '/signup'
        req.headers['Content-Type'] = 'application/json'
        req.body = "{ \"user\": {\"name\": \"#{user_name}\", \"password\": \"#{pwd}\",
                    \"password_confirmation\": \"#{pwd_conf}\"}, \"dispather_code\": \"#{dispather_code}\"}"
      end

      obj = Oj.load(response.body, {:mode => :object })
      if response.status == 201
        token = obj["token"]
        if token
          session[:token] = token
          session[:role] = obj["role"]
          session[:user_name] = user_name
          redirect_to :controller => 'tasks', :action => 'index'
        end
        puts "ALL Ok"
      else
        flash[:error] = "Smth wrong with params #{obj["exception"]}"
        render 'new'
      end
    else
    end
  end
end
