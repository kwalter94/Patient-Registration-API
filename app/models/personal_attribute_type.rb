class PersonalAttributeType < ApplicationRecord
    belongs_to :personal_attribute
    validates :name, presence: true
end
