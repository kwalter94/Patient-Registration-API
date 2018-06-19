class PersonalAttribute < ApplicationRecord
    has_one :personal_attribute_type
    belongs_to :person
    validates :value, presence: true
    validates :person_id, presence: true
end
