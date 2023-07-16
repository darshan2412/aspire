class User < ApplicationRecord
  has_secure_password

  validates_uniqueness_of :email
  validates_presence_of :email, :password_digest

  def customer?
    type == 'Customer'
  end

  def admin?
    type == 'Admin'
  end
end

