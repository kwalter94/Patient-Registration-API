class PersonalAttribute < ApplicationRecord
    has_one :personal_attribute_type
    belongs_to :person
    validates_presence_of :value, :person
end
