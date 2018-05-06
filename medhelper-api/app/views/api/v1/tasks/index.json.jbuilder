if !is_current_user_operator()
  json.array! @tasks do |task|
    json.id task.id
    json.title task.title
    json.patient task.patient
    json.doctor task.user.name
    json.diagnosis task.diagnosis
  end
else
  json.array! @tasks do |task|
    json.id task.id
    json.title task.title
    json.patient task.patient
    json.doctor task.user.name
  end
end