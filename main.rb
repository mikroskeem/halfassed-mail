#!/usr/bin/env ruby

require 'webrick'
require 'json'
require 'rotp'
require 'rqrcode'
# require 'mysql2'

require_relative 'data/attachment'

require_relative 'utils/mail'

require_relative 'routes/mailgun_route'
require_relative 'routes/root_route'
require_relative 'routes/qr_route'

server = WEBrick::HTTPServer.new(Port: ARGV.first || '8080')
# mysql = Mysql2::Client.new(:host => "127.0.0.1", :username => "root", :password => "replace_this_later")

# mysql_table = File.open("tables.sql", "r") { |f| f.read }

server.mount_proc '/', HalfassedMail::Routes::RootRoute
server.mount_proc '/qr', HalfassedMail::Routes::QrRoute
server.mount_proc '/mg', HalfassedMail::Routes::MailgunRoute

trap 'INT' do
  server.shutdown
end
server.start
