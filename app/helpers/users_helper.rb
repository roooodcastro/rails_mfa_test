module UsersHelper
  def user_mfa_qrcode(user)
    qrcode = RQRCode::QRCode.new(user.mfa_url)
    svg = qrcode.as_svg(offset: 0, color: '000',
                        shape_rendering: 'crispEdges',
                        module_size: 4)
    svg.html_safe
  end
end
