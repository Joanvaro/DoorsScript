#!/usr/bin/ruby

$fileName = ARGV[0]
$className = String.new()
$methods = Hash.new()
$attributes = Hash.new()

$data = File.readlines($fileName)
$publicLine = 0
$protectedLine = 0
$privateLine = 0

def getAttributes(line)
  for i in 0..50 do 
    attributeName = $data[line + i].match(/[m,c]_\w+/)
    $attributes[attributeName.to_s] = Array.new() unless $attributes.has_key?(attributeName.to_s)
    $attributes[attributeName.to_s].push( $data[line + i].strip )

    break if $data[line + i + 1].match(/end/)
  end
end

def getSpecs(line, methodName) 
  iterator = $data.find_index(line) + 1

  while ( !$data[iterator].strip.eql?("*/") ) do 

    if( $data[iterator].match?(/@param/) )
      $methods[methodName][:parameters] = Array.new() unless $methods[methodName].has_key?(:parameters) 
      $methods[methodName][:parameters].push( $data[iterator].strip.sub(/\* @param/,'') )

    elsif( $data[iterator].match?(/@return/) ) 
      $methods[methodName][:return] = Array.new() unless $methods[methodName].has_key?(:return)
      $methods[methodName][:return].push( $data[iterator].strip.sub(/\* @return/,'') )

    elsif( $data[iterator].match?(/@throw/) )
      $methods[methodName][:throw] = Array.new() unless $methods[methodName].has_key?(:throw)
      $methods[methodName][:throw].push( $data[iterator].strip.sub(/\* @throw/, '') )

    elsif( $data[iterator].match?(/@exception/) )
      $methods[methodName][:exceptions] = Array.new() unless $methods[methodName].has_key?(:exceptions)
      $methods[methodName][:exceptions].push( $data[iterator].strip.sub(/\* @exception/, '') )

    else
      $methods[methodName][:description] = Array.new() unless $methods[methodName].has_key?(:description)
      $methods[methodName][:description].push( $data[iterator].strip.sub(/\*/, '') )
    end

    iterator += 1
  end
  
end

def getPublicMethods(numberLine)
  
  line = $data[numberLine] 
  # It is looking for comments only
  if line.match(/@brief/) 
    # It is looking for the class name
    if line.match(/class/)
      arry = line.split
      $className = arry[-2]

    else
      func = line.split
      $methods[func[-1]] = Hash.new()
      getSpecs(line, func[-1])
    end
  end
end

line = 0
$data.each do |lines|
  if lines.match(/public/)
    $publicLine = line
  elsif lines.match(/protected/)
    $protectedLine = line
  elsif lines.match(/private/)
    $privateLine = line
  end

  line += 1
end

#if ($publicLine < $protectedLine) 
  ($publicLine..$privateLine).each do |public|
    getPublicMethods(public)
  end

  getAttributes($privateLine)

puts $className
puts $methods
puts
puts $attributes 
