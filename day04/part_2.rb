INPUT_FILENAME = 'input.txt'
TARGET_STRING_CENTER = 'A'
TARGET_DIAGONAL_VALUES = ['M','S']
SHIFT_COMBOS = [[1,1],[-1,1]]

puzzle_array = File.readlines(INPUT_FILENAME).map(&:chars)

def diagonals_match(puzzle_array, row, col)
  SHIFT_COMBOS.all? do |combo|
    diagonal = [1,-1].map do |modifier|
      shifted_row = row + (combo[0] * modifier)
      shifted_col = col + (combo[1] * modifier)
      return false if shifted_row < 0 || shifted_col < 0
      puzzle_array[shifted_row]&.[](shifted_col).to_s
    end
    diagonal.sort == TARGET_DIAGONAL_VALUES
  end
end

count = puzzle_array.each_with_index.sum do |row, row_index|
  row.each_with_index.count do |value, col_index|
    value == TARGET_STRING_CENTER && diagonals_match(puzzle_array, row_index, col_index)
  end
end

puts count