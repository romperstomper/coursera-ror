json.extract! todolist, :id, :list_name, :list_due_date, :created_at, :updated_at
json.url todolist_url(todolist, format: :json)
