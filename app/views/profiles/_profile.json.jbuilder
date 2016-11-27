json.extract! profile, :id, :first_name, :middle_name, :last_name, :gender, :friends, :location, :created_at, :updated_at
json.url profile_url(profile, format: :json)