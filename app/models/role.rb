class Role < ApplicationRecord
  SERIALIZE_OPTIONS = {
    include: {
      privileges: Privilege::SERIALIZE_OPTIONS
    }
  }

  has_and_belongs_to_many :privileges
  has_many :users
  validates :rolename, presence: true

  def as_json(options = {})
    super(options.merge(SERIALIZE_OPTIONS))
  end
end
