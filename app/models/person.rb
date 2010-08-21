require 'digest/sha1'

class Person < ActiveRecord::Base
  has_many :promises

  validates_presence_of :e_mail
  validates_uniqueness_of :e_mail

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  validate :password_non_blank

  attr_accessor :promises_kept, :promises_broken, :promises_in_the_works, :latest_closed_promises, :promises_close_to_expiry


  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = Person.encrypted_password(self.password, self.salt)
  end

  def self.authenticate(e_mail, password)
    person = self.find_by_e_mail(e_mail)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        person = nil
      end
    end
    person
  end

  def to_s
    return name unless name.nil?
  end

private
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

end
