module HalfassedMail
  module Routes


    class QrRoute < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(req, res)
        message = req.query['text'] || 'Add ?text=Hello to get your own text here'
        if message.length > 150
          message = "Message is too long, was #{message.length}/150"
        end

        # Some day registrations will be done using TOTP
        qrcode = RQRCode::QRCode.new(message)
        res.body = qrcode.as_png.to_s
      end
    end


  end
end