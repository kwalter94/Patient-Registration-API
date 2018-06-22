require 'securerandom'

require 'utils/string_utils'

class User < ApplicationRecord
  SERIALIZE_OPTIONS = {
    except: [:password, :salt],
    include: {
      role: Role::SERIALIZE_OPTIONS,
      person: Person::SERIALIZE_OPTIONS
    }
  }

  belongs_to :person, optional: true
  belongs_to :role
  validates_presence_of :username, :password, :role

  before_create :before_create

  def self.authenticate(username, password)
    user = User.find_by_username(username)
    user && user.validate_password?(password) ? user : nil
  end

  def before_create
    self.uuid = SecureRandom.uuid
  end

  def as_json(options = {})
    super(options.merge(SERIALIZE_OPTIONS))
  end

  def destroy
    person.destroy source = :user
    super()
  end

  def set_password(plain_password)
    self.salt = SecureRandom.base64 SALT_LENGTH if self.salt.nil?
    self.password = encrypt plain_password, self.salt
  end

  # Returns an encrypted `password` using the given salt
  def encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt)
  end

  # Validate password against user's password
  #
  # Returns true on success else false
  def validate_password?(plain_password)
    encrypt(plain_password, salt) == self.password
  end

  private
    SALT_LENGTH = 128
end
