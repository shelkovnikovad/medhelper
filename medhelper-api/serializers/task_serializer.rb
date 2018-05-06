class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :diagnosis
end