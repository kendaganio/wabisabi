class ListSerializer
  include FastJsonapi::ObjectSerializer

  set_type :list
  attributes :name, :created_at, :updated_at
end
