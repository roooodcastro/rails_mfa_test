module UsersHelper
  def user_mfa_qrcode(user)
    qrcode = RQRCode::QRCode.new(user.mfa_uri)
    svg = qrcode.as_svg(module_size: 3)
    svg.html_safe
  end
end
