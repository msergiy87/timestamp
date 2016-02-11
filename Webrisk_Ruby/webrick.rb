#!/usr/bin/env ruby
require 'webrick'

def timestamp
  Time.now.to_i
end

server = WEBrick::HTTPServer.new :Port => 8080
server.mount_proc '/' do |req, res|
  res.body = "#{timestamp}"
end

trap('INT') { server.stop } # stop server with Ctrl-C
server.start
