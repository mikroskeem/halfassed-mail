require 'data/attachment'

require 'webrick'
require 'json'
require 'rotp'
require 'rqrcode'
# require 'mysql2'

server = WEBrick::HTTPServer.new(Port: ARGV.first || '8080')
# mysql = Mysql2::Client.new(:host => "127.0.0.1", :username => "root", :password => "replace_this_later")

# mysql_table = File.open("tables.sql", "r") { |f| f.read }

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

server.mount_proc '/' do |req, res|
  res.status = 200
  res['Content-Type'] = 'application/json'
  res.body = if req.path.end_with?('.json') || req.path.start_with?('/.')
               JSON.pretty_generate(whoIsFat: 'Your Mom!')
             else
               JSON.pretty_generate(message: 'Hello World!')
             end
end

server.mount_proc '/qr' do |req, res|
  message = req.query['text'] || 'Add ?text=Hello to get your own text here'
  if message.length > 150
    message = "Message is too long, was #{message.length}/150"
  end

  # Some day registrations will be done using TOTP
  qrcode = RQRCode::QRCode.new(message)
  res.body = qrcode.as_png.to_s
end

server.mount_proc '/mg' do |req, res|
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

trap 'INT' do
  server.shutdown
end
server.start
