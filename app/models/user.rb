class User < ApplicationRecord
    has_and_belongs_to_many :roles
    belongs_to :person
    validates_presence_of :username, :password, :roles
end
