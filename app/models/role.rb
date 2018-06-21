class Role < ApplicationRecord
    has_and_belongs_to_many :users
    has_many :privileges
    validates :rolename, presence: true
end
