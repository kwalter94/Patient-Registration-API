class Patient < ApplicationRecord
    SERIALIZE_OPTIONS = {
        include: {
            person: Person::SERIALIZE_OPTIONS
        }
    }

    belongs_to :person, optional: true
    validates :person, presence: true

    def destroy
        person.destroy source = :patient
        super() # destroy self
    end
end
