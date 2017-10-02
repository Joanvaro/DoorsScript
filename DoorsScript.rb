#!/usr/bin/ruby

$fileName = ARGV[0]
$className = String.new()
$methods = Hash.new()
$attributes = Hash.new()

$data = File.readlines($fileName)

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
      getSpecs(lines, func[-1])
    end
  end

end

puts $className
puts $methods
