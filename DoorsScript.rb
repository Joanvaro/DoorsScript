#!/usr/bin/ruby

fileName = ARGV[0]
className = String.new()
methods = Hash.new()
attributes = Hash.new()

data = File.readlines(fileName)

data.each do |lines|
  if lines.match?(/@brief/) 
    if lines.match?(/class/)
      arry = lines.split
      className = arry[-2]
    end
  end

end

puts className
