require 'securerandom'

class User < ApplicationRecord
    SALT_LENGTH = 128

    has_and_belongs_to_many :roles
    belongs_to :person
    validates_presence_of :username, :password, :roles

    before_create :before_create

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
end
