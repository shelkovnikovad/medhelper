
  if !is_current_user_operator()
    json.id @task.id
    json.title @task.title
    json.patient @task.patient
    json.doctor @task.user.name
    json.doctor_id @task.user.id
    json.diagnosis @task.diagnosis
  else
    json.id @task.id
    json.title @task.title
    json.patient @task.patient
    json.doctor @task.user.name
    json.doctor_id @task.user.id
  end
