class User < ApplicationRecord
    has_many :roles, through :user_roles
    belongs_to: person
end
