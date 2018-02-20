module HalfassedMail
  module Utils
    module Mail


      def parse_message_headers(form)
        headers = {}
        parsed = JSON.parse(form)
        parsed.each { |list| headers[list.shift] = list.shift }
        headers
      end

      def parse_attachments(form)
        attachments = []
        parsed = JSON.parse(form)
        parsed.each do |at|
          attachments.push(Attachment.new(at['url'], at['name'], at['content-type'], at['size']))
        end
        attachments
      end


    end
  end
end