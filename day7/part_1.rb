INPUT_FILENAME = 'input.txt'

def valid_test_values?(target, processed_values, remaining_values)
  return false if processed_values.empty?
  return processed_values.include?(target) if remaining_values.empty?

  new_processed = []
  next_input = remaining_values.shift

  processed_values.each do |value|
    addition_result = value + next_input
    new_processed << addition_result if addition_result <= target
    mult_result = value * next_input
    new_processed << mult_result if mult_result <= target
  end
  valid_test_values?(target, new_processed, remaining_values)
end

valid_sum = 0

File.foreach(INPUT_FILENAME).with_index do |line, row_idx|
  stripped_line = line.strip
  next if stripped_line.empty?

  target, inputs = stripped_line.split(':')
  target = target.to_i
  inputs = inputs.split.map(&:to_i)

  # Initialize with the first value from the input
  initial_value = [inputs.shift]

  # Check if the target value is achievable
  valid_sum += target if valid_test_values?(target, initial_value, inputs)
end

puts valid_sum