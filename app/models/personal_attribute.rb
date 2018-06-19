class PersonalAttribute < ApplicationRecord
    has_one :personal_attribute_type
    belongs_to :person
end
