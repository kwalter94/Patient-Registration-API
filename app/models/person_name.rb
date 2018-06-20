class PersonName < ApplicationRecord
    belongs_to :person
    validates :person, presence: true
end
