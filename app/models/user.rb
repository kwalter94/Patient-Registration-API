class User < ApplicationRecord
    has_many :roles, :through => 'user_roles'
    belongs_to :person
    validates :username, presence: true
    validates :password, presence: true
    validates :active, presence: true
end
