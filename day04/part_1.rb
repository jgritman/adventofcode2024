INPUT_FILENAME = 'input.txt'
TARGET_STRING_START = 'X'
TARGET_STRING_SUFFIX = 'MAS'
SHIFT_RANGE = 1..TARGET_STRING_SUFFIX.length
SHIFT_VALUES = (-1..1).to_a
SHIFT_COMBOS = SHIFT_VALUES.product(SHIFT_VALUES).reject { |combo| combo == [0, 0] }

puzzle_array = File.readlines(INPUT_FILENAME).map(&:chars)

def check_direciton(puzzle_array, row, col, shift_combo)
  result = ""
  SHIFT_RANGE.each do |i|
    shifted_row = (shift_combo[0] * i) + row
    shifted_col = (shift_combo[1] * i) + col
    return false if shifted_row < 0 || shifted_col < 0
    result += puzzle_array[shifted_row]&.[](shifted_col).to_s
  end
  result == TARGET_STRING_SUFFIX
end

def find_matches(puzzle_array, row, col)
  SHIFT_COMBOS.count { |combo| check_direciton(puzzle_array, row, col, combo)}
end

count = puzzle_array.each_with_index.sum do |row, row_index|
  row.each_with_index.sum do |value, col_index|
    value == TARGET_STRING_START ? find_matches(puzzle_array, row_index, col_index) : 0
  end
end

puts count