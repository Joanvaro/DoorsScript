#!/usr/bin/ruby

fileName = ARGV[0]

puts fileName

File.open(fileName, "r") { |data|

  puts data.readlines

}  

