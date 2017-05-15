json.extract! user, :id, :password_digest, :usernamer, :created_at, :updated_at
json.url user_url(user, format: :json)
