require 'faraday'
require 'oj'

#Create User
client = Faraday.new(url: 'http://localhost:3000') do |config|
  config.adapter Faraday.default_adapter
end

response = client.post do |req|
  req.url '/api/v1/users'
  req.headers['Content-Type'] = 'application/json'
  req.body = '{ "user": {"name": "test user2"} }'
end

#Create task
client = Faraday.new(url: 'http://localhost:3000') do |config|
  config.adapter  Faraday.default_adapter
  config.token_auth('0ac91ad54650340328bcb79d1e970121')
end

response = client.post do |req|
  req.url '/api/v1/tasks'
  req.headers['Content-Type'] = 'application/json'
  req.body = '{ "post": {"title": "Title", "diagnosis": "Text"} }'
end

#Delete Task
response = client.delete do |req|
  req.url '/api/v1/tasks/51'
  req.headers['Content-Type'] = 'application/json'
end

obj = Oj.object_load(response.body,:mode => :compat)
puts response.body
puts response.status