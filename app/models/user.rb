class User < ApplicationRecord
    has_and_belongs_to_many :roles
    belongs_to :person
    validates :username, presence: true
    validates :password, presence: true
    validates :active, presence: true
end
