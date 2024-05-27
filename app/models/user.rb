class User < ApplicationRecord
  has_secure_password

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }

  def self.authenticate_with_credentials(email, password)
    sanitized_email = email.strip.downcase
    user = User.find_by(email: sanitized_email)
    return user if user && user.authenticate(password)
    nil
  end
end
