class Person < ApplicationRecord
  SERIALIZE_OPTIONS = {
    include: {
      person_name: PersonName::SERIALIZE_OPTIONS,
      personal_attributes: PersonalAttribute::SERIALIZE_OPTIONS
    }
  }

  has_one :user
  has_one :patient
  has_one :person_name, validate: true
  has_many :personal_attributes

  # NOTE: Cases of people who do not know their date of birth
  # are encountered sometimes hence allowing Persons without
  # date of birth below...
  validates :birthdate, presence: false
  validates_presence_of :gender, :person_name

  def as_json(options = {})
    super(options.merge(SERIALIZE_OPTIONS))
  end

  # Destroy self if there is no patient and/or user attached.
  #
  # Parameters:
  #   ignore - Valid values are :patient or :user. Model specified here
  #            is not checked if its attached.
  #
  # Returns: true if successful else false
  def destroy(ignore = nil)
    okay_to_destroy = (ignore == :patient && user.nil?) \
                      || (ignore == :user && patient.nil?) \
                      || (ignore.nil? && user.nil? && patient.nil?)
    okay_to_destroy ? super() : false
  end
end
