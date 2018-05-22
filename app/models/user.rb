class User < ApplicationRecord
  has_secure_password

  has_many :nonce_tokens, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  # Hack, don't do this in production!
  def admin?
    name == 'admin'
  end

  # If the mfa_secret column is present, the user is using 2FA
  def mfa?
    mfa_secret.present?
  end

  # Creates a 2FA secret token for this user, along with 10 unique nonce tokens.
  # A nonce token is a token that can be used in place of the regular 6-digit
  # 2FA code. Each nonce can be used only once and expires after its use.
  def generate_mfa_secret!
    transaction do
      update!(mfa_secret: SecureRandom.hex(16))
      Array.new(10) { nonce_tokens.build.save! }
    end
  end

  # Sets the 2FA secret token to nil, signalling the user doesn't want to use
  # MFA anymore. This also deletes all of his nonce tokens, used or unused.
  def remove_mfa_secret!
    transaction do
      update!(mfa_secret: nil)
      nonce_tokens.delete_all
    end
  end

  # Generates a otpauth:// URI, with the secret token, the user name and the
  # 2FA issuer (this application).
  def mfa_uri
    totp = ROTP::TOTP.new(Base32.encode(mfa_secret), issuer: 'Rails MFA')
    totp.provisioning_uri(name)
  end

  # First tries to log in using the time-based MFA device (mobile phone). If
  # this fails, tries to authenticate using one of the user's nonce tokens,
  # invalidating it.
  def authenticate_mfa(token)
    return false unless mfa? && token.present?
    return true if ROTP::TOTP.new(Base32.encode(mfa_secret)).verify(token)
    NonceToken.authenticate(self, token)
  end
end
