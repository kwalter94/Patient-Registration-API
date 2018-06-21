class Person < ApplicationRecord
    has_one :patient
    has_one :person
    has_one :person_name
    has_many :personal_attributes

    # NOTE: Cases of people who do not know their date of birth
    # are encountered sometimes hence allowing Persons without
    # date of birth below...
    validates :birthdate, presence: false
    validates :gender, presence: true
end
