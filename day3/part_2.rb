MUL_PATTERN = /mul\((\d+),(\d+)\)/
DELIMTER_PATTERN=/(?:\A|do\(\))(.*?)(?:don't\(\)|\z)/m

def process_mults(input)
  mul_matches = input.scan(MUL_PATTERN).map { |m| m.map(&:to_i) }
  mults = mul_matches.map { |inputs| inputs[0] * inputs[1] }.sum
end

file_content = File.read('input')
matching_instructions = file_content.scan(DELIMTER_PATTERN)
sum = matching_instructions.map { |m| process_mults(m.first) }.sum

puts sum
