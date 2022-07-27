class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /@/,
                              message: "must be valid" }
  validates :password_hash, presence: true

  has_many :cards
  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
