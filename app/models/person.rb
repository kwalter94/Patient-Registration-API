class Person < ApplicationRecord
    has_one :patient
    has_one :person_name
    has_many :personal_attributes
end
