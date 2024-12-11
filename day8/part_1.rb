require 'set'

INPUT_FILENAME = 'input.txt'

antennas_to_pos = Hash.new { |hash, key| hash[key] = [] }
grid_length, grid_width = 0, 0

# Parse the input file and build antennas_to_pos
File.foreach(INPUT_FILENAME).with_index do |line, row_idx|
  stripped_line = line.strip
  next if stripped_line.empty?

  row_chars = stripped_line.chars
  grid_length += 1
  grid_width = row_chars.length

  row_chars.each_with_index do |char, col_idx|
    if char.match?(/[a-zA-Z0-9]/)
      antennas_to_pos[char] << [row_idx, col_idx]
    end
  end
end

def in_bounds?(row, col, grid_length, grid_width)
  row.between?(0, grid_length - 1) && col.between?(0, grid_width - 1)
end

antinodes = Set.new

antennas_to_pos.each_value do |positions|
  positions.combination(2).each do |(first_row, first_col), (second_row, second_col)|
    row_diff = first_row - second_row
    col_diff = first_col - second_col

    [
      [first_row + row_diff, first_col + col_diff],
      [second_row - row_diff, second_col - col_diff]
    ].each do |antinode_row, antinode_col|
      antinodes << [antinode_row, antinode_col] if in_bounds?(antinode_row, antinode_col, grid_length, grid_width)
    end
  end
end

puts antinodes.length