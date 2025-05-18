class User < ApplicationRecord
  before_create :generate_token

  has_one :author, dependent: :destroy
  has_many :likes, dependent: :destroy

  def generate_token
    self.token = SecureRandom.hex
  end
end
