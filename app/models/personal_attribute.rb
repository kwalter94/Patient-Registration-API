class PersonalAttribute < ApplicationRecord
    SERIALIZE_OPTIONS = {
        include: {
            personal_attribute_type: PersonalAttributeType::SERIALIZE_OPTIONS
        }
    }

    belongs_to :personal_attribute_type
    belongs_to :person
    validates_presence_of :value, :person

    def as_json(options = {})
        super(options.merge(SERIALIZE_OPTIONS))
    end
end
