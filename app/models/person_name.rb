class PersonName < ApplicationRecord
    SERIALIZE_OPTIONS = {}

    belongs_to :person
    validates_presence_of :person, :firstname, :lastname
end
