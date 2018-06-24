class Patient < ApplicationRecord
    SERIALIZE_OPTIONS = {
        include: {
            person: Person::SERIALIZE_OPTIONS
        }
    }

    belongs_to :person
    validates :person, presence: true

    def destroy
        person.destroy ignore = :patient
        super() # destroy self
    end
end
