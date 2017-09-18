#!/usr/bin/ruby

$fileName = ARGV[0]
$className = String.new()
$methods = Hash.new()
$attributes = Hash.new()

$data = File.readlines($fileName)

def getSpecs(methodName) 
  iterator = $data.find_index(methodName)
  puts iterator
end


$data.each do |lines|
  # It is looking for comments only
  if lines.match(/@brief/) 
    # It is looking for the class name
    if lines.match(/class/)
      arry = lines.split
      $className = arry[-2]

    else

      func = lines.split
      $methods[func[-1]] = Hash.new()
      getSpecs(lines)
    end
  end

end

puts $className
puts $methods
