class TasksController < ApplicationController
  before_action :authorize
  require 'faraday'
  require 'oj'

  def new
    @users = get_users
  end

  def edit
    @task_id = params[:id]
    response = get_client_api.get do |req|
      req.url "/api/v1/tasks/#{@task_id}"
    end

    @task = Oj.load(response.body, {:mode => :object })
    @users = get_users

  end

  def add_params(params_hash)
    result_str = ''

    params_hash.each do |key, value|
      if !value.nil?
        result_str += "\"#{key}\": \"#{value}\","
      end
    end

    if result_str.length > 1
      result_str = result_str[0..result_str.length()-2]
    end

    return result_str
  end

  def update
    task_id = params[:id]
    hash_params = {doctor_id: params[:doctor_id], title: params[:title], patient: params[:patient],
                   task_id: task_id, diagnosis: params[:diagnosis], status: params[:task_status]
                  }
    response = nil
    body = add_params(hash_params)
    if body.length > 1 and task_id
      response = get_client_api.put do |req|
        req.url "/api/v1/tasks/#{task_id}"
        req.headers['Content-Type'] = 'application/json'
        req.body = "{#{body}}"
        print req.body
      end
    end

    obj = Oj.load(response.body, {:mode => :object })
    if response.status == 200
      flash[:success] = "Task edited"
      redirect_to :controller => 'tasks', :action => 'index'
      return
    end

    redirect_to :controller => 'tasks', :action => 'index'
  end

  def create
    doctor_id = params[:doctor_id]
    title = params[:title]
    patient = params[:patient]

    response = get_client_api.post do |req|
      req.url '/api/v1/tasks'
      req.headers['Content-Type'] = 'application/json'
      req.body = "{\"title\": \"#{title}\", \"patient\": \"#{patient}\", \"user_id\": #{doctor_id}}"

    end

    obj = Oj.load(response.body, {:mode => :object })
    if response.status == 201
      flash[:success] = "Task created"
      redirect_to :controller => 'tasks', :action => 'index'
    end
  end

  def index

    response = get_client_api.get do |req|
      req.url '/api/v1/tasks'
    end

    @tasks = Oj.load(response.body, {:mode => :object })
    print @tasks.size
  end

  def complete
    @task_id = params[:id]
    response = get_client_api.get do |req|
      req.url "/api/v1/tasks/#{@task_id}"
    end

    @task = Oj.load(response.body, {:mode => :object })

  end
  def delete_task
    task_id = params[:id]

    if !task_id.nil?
      response = get_client_api.delete do |req|
        req.url "/api/v1/tasks/#{task_id}"
      end

      if response.status == 401
        flash[:success] = "Task deleted"
        redirect_to :controller => 'tasks', :action => 'index'
        return
      end
    end

    flash[:success] = "Task not deleted"
    redirect_to :controller => 'tasks', :action => 'index'
  end

  private
  def get_users()
    response = get_client_api.get do |req|
      req.url '/api/v1/users'
    end

    Oj.load(response.body, {:mode => :object })
  end
end
