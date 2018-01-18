#!/usr/bin/env ruby
require 'filewatcher'
require 'rest-client'

run = true
server_address = 'localhost:3000'
def name(filename)
  a = filename.dup
  a.delete!("\n")
  a.split('/').last
end

Filewatcher.new('files/').watch do |filename, event|
  if name(filename).eql?('pipe.msg')
    data = File.read(filename)
    if data == '0'
      run = false
    end

    if data == '1'
      run = true
    end
  elsif run
    if event.eql?('deleted')
      RestClient.post "#{server_address}/file", type: event
    else
      RestClient.post "#{server_address}/file", file: File.new(filename), type: event
    end
  else
    puts 'couldnt'
  end
end

