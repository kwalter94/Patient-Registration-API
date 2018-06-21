class PersonalAttributeType < ApplicationRecord
    SERIALIZE_OPTIONS = {}

    belongs_to :personal_attribute
    validates :name, presence: true
end
