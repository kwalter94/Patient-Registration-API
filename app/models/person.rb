class Person < ApplicationRecord
	SERIALIZE_OPTIONS = {
		include: {
			person_name: PersonName::SERIALIZE_OPTIONS,
			personal_attributes: PersonalAttribute::SERIALIZE_OPTIONS
		}
	}

  has_one :user
	has_one :patient
	has_one :person_name
	has_many :personal_attributes

	# NOTE: Cases of people who do not know their date of birth
	# are encountered sometimes hence allowing Persons without
	# date of birth below...
	validates :birthdate, presence: false
	validates :gender, presence: true

	def as_json(options = {})
		super(options.merge(SERIALIZE_OPTIONS))
	end

	# Destroy self if there is no patient or user attached.
	#
	# Parameters:
	#   source - This provides a hint on how the destroy
	#            should be executed.
	#
	#            If source is :patient then destroy executes
	#            only if there is no :user attached and if
	#            source is :user then destroy executes only if
	#            there is no :patient attached.
	def destroy(source = nil)
		case source
		when :patient
			return false unless user.nil?
		when :user
			return false unless patient.nil?
    else
			return false
    end

    person_name.destroy unless person_name.nil?
    personal_attributes.destroy
		super() # Destroy self
	end
end
