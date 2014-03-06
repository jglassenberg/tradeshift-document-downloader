module QrcodeHelper
  require 'rqrcode'

  def render_qr_code text, size = 4
    return if text.to_s.empty?
    qr = RQRCode::QRCode.new(text, size: 5, level: :h)
    sizeStyle = "width: #{size}px; height: #{size}px;"

    content_tag :table, class: "qrcode pull-left" do
      qr.modules.each_index do |x|
        concat(content_tag(:tr) do
          qr.modules.each_index do |y|
            if qr.dark? x, y
              concat content_tag(:td, nil, class: "black", style: sizeStyle)
            else
              concat content_tag(:td, nil, class: "white", style: sizeStyle)
            end
          end
        end)
      end
    end
  end
end
