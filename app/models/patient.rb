class Patient < ApplicationRecord
    belongs_to :person
    validates :person_name, presence: true
end
