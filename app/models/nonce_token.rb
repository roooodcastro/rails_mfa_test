class NonceToken < ApplicationRecord
  belongs_to :user

  validates :token, presence: true, uniqueness: true

  before_validation(on: :create) { self.token = SecureRandom.hex(16) }

  def self.authenticate(user, token)
    token = NonceToken.find_by(user: user, token: token, used: false)
    return false unless token
    token.update(used: true)
  end
end
