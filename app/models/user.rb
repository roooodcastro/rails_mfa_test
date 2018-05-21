class User < ApplicationRecord
  has_secure_password

  has_many :nonce_tokens, dependent: :destroy

  validates :name, presence: true
  validates :password, presence: true, on: :create

  def has_mfa?
    mfa_secret.present?
  end

  def generate_mfa_secret!
    transaction do
      update!(mfa_secret: SecureRandom.hex(16))
      Array.new(10) { nonce_tokens.build.save! }
    end
  end

  def remove_mfa_secret!
    transaction do
      update!(mfa_secret: nil)
      nonce_tokens.each { |token| token.destroy! }
    end
  end

  def mfa_url
    totp = ROTP::TOTP.new(Base32.encode(mfa_secret), issuer: 'Rails MFA')
    totp.provisioning_uri(name)
  end

  # First tries to log in using the time-based MFA device (mobile phone). If
  # this fails, tries to authenticate using one of the user's nonce tokens,
  # invalidating it.
  def authenticate_mfa(token)
    return false unless has_mfa? && token.present?
    return true if ROTP::TOTP.new(Base32.encode(mfa_secret)).verify(token)
    NonceToken.authenticate(self, token)
  end
end
