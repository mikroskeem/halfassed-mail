require 'webrick'
require 'json'
require 'rotp'
require 'rqrcode'
#require 'mysql2'

server = WEBrick::HTTPServer.new(:Port => ARGV.first || "8080")
#mysql = Mysql2::Client.new(:host => "127.0.0.1", :username => "root", :password => "replace_this_later")

server.mount_proc "/" do |req, res|
    res.status = 200
    res["Content-Type"] = "application/json"
    res.body = JSON.pretty_generate({:message => "Hello World!"})
end

server.mount_proc "/qr" do |req, res|
    # Some day registrations will be done using TOTP
    qrcode = RQRCode::QRCode::new("Hello")
    res.body = qrcode.as_png().to_s
end

server.mount_proc "/mg" do |req, res|
    # If query is empty, return early
    if req.request_method == "POST" and !req.query.empty?
        res.status = 200
        res["Content-Type"] = "application/json"

        # TODO: figure out how to get one header from headers
        req.query["message-headers"].list().each { |k, v|
            puts "#{k} --> #{v}"
        }

        puts
        puts "From: #{req.query["sender"]} (\"#{req.query["From"]}\")"
        puts "To: #{req.query["recipient"]} (\"#{req.query["To"]}\")"
        #puts "Content-Type: #{req.query["message-headers"]["Content-Type"]}"
        puts
        puts "#{req.query["subject"]}"
        puts
        puts "#{req.query["stripped-text"]}"

        res.body = JSON.pretty_generate({:message => "Ok. Gotcha"})
    else
        raise "Not allowed"
    end
end

trap 'INT' do server.shutdown end
server.start
