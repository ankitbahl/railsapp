#!/usr/bin/env ruby
require 'filewatcher'
run = true
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
    puts filename
    puts event
  else
    puts 'couldnt'
  end
end

