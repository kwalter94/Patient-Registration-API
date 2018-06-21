class Person < ApplicationRecord
    SERIALIZE_OPTIONS = {
        include: {
            person_name: PersonName::SERIALIZE_OPTIONS,
            patient: Patient::SERIALIZE_OPTIONS,
            personal_attributes: PersonalAttribute::SERIALIZE_OPTIONS
        }
    }

    has_one :patient
    has_one :person_name
    has_many :personal_attributes

    # NOTE: Cases of people who do not know their date of birth
    # are encountered sometimes hence allowing Persons without
    # date of birth below...
    validates :birthdate, presence: false
    validates :gender, presence: true

    def as_json(options = {})
        super(options.merge(SERIALIZE_OPTIONS))
    end
end
