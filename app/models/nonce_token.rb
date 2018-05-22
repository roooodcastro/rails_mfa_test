class NonceToken < ApplicationRecord
  attribute :token, :string, default: -> { SecureRandom.hex(16) }

  belongs_to :user

  validates :token, presence: true, uniqueness: true

  def self.authenticate(user, token)
    token = NonceToken.find_by(user: user, token: token, used: false)
    token&.update(used: true)
  end
end
