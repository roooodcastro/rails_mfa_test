

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :password, presence: true, on: :create

  def has_mfa?
    mfa_secret.present?
  end

  def generate_mfa_secret!
    update!(mfa_secret: SecureRandom.hex(16))
  end

  def remove_mfa_secret!
    update!(mfa_secret: nil)
  end

  def mfa_url
    totp = ROTP::TOTP.new(Base32.encode(mfa_secret), issuer: 'Rails MFA')
    totp.provisioning_uri(name)
  end

  def authenticate_mfa(token)
    return false unless has_mfa? && token.present?
    ROTP::TOTP.new(Base32.encode(mfa_secret)).verify(token)
  end
end
