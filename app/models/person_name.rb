class PersonName < ApplicationRecord
    SERIALIZE_OPTIONS = {}

    belongs_to :person
    validates :person, presence: true
end
