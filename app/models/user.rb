require 'securerandom'

class User < ApplicationRecord
    SALT_LENGTH = 128

    has_and_belongs_to_many :roles
    belongs_to :person
    validates_presence_of :username, :password, :roles

    before_create :before_create

    def self.authenticate(login, password)
      user = where(["username = ?", login]).first
      user && user.validate_password?(password) ? user : nil
    end

    def before_create
      self.uuid = SecureRandom.uuid
    end

    def set_password(plain_password)
      self.salt = SecureRandom.base64 SALT_LENGTH
      self.password = encrypt plain_password, self.salt
    end

    # Returns an encrypted `password` using the given salt
    def encrypt(password, salt)
      Digest::SHA1.hexdigest(password + salt)
    end

    # Validate password against user's password
    #
    # Returns true on success else false
    def validate_password?(password)
      encrypt(password, self.salt) == self.password
    end
end
