class Role < ApplicationRecord
    has_many :users, :through => 'user_roles'
    validates :rolename, presence: true
end
