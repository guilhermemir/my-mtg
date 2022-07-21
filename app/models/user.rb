class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /@/,
                              message: "must be valid" }

  has_many :cards
end
