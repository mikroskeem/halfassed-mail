module HalfassedMail
  module Routes


    class MailgunRoute < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(req, res)
        # If query is empty, return early
        if (req.request_method == 'POST') && !req.query.empty?
          res.status = 200
          res['Content-Type'] = 'application/json'

          # Parse message headers and attachments
          headers = parse_message_headers(req.query['message-headers'])
          attachments = if req.query['attachments'].nil?
                          nil
                        else
                          parse_attachments(req.query['attachments'])
                        end

          puts req.query

          puts
          puts "From: #{req.query['sender']} (\"#{req.query['From']}\")"
          puts "To: #{req.query['recipient']} (\"#{req.query['To']}\")"
          puts "Content-Type: #{headers['Content-Type']}"
          puts
          puts req.query['subject'].to_s
          puts
          puts req.query['stripped-text'].to_s
          unless attachments.nil?
            puts
            puts 'Attachments: '
            attachments.each do |attachment|
              puts "- #{attachment}"
            end
          end

          res.body = JSON.pretty_generate(message: 'Ok. Gotcha')
        else
          raise 'Not allowed'
        end
      end
    end


  end
end