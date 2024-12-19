MUL_PATTERN = /mul\((\d+),(\d+)\)/
sum = 0
File.foreach('input') do |line|
  mul_matches = line.scan(MUL_PATTERN).map { |m| m.map(&:to_i) }
  mul_matches.each { |inputs| sum += inputs[0] * inputs[1] }
end
puts sum