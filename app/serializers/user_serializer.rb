class UserSerializer < ApplicationSerializer
  attributes :id, :username, :email, :created_at, :updated_at
end

