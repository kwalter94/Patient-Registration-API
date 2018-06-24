class PersonalAttributeType < ApplicationRecord
    SERIALIZE_OPTIONS = {}

    has_many :personal_attribute
    validates :name, presence: true
end
