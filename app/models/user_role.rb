class UserRole < ApplicationRecord
  validates :user_id, presence: true
  validates :role_id, presence: true
end
