class TaskSerializer
  include FastJsonapi::ObjectSerializer

  set_type :task
  attributes :description, :status, :created_at, :updated_at
  belongs_to :user
end
