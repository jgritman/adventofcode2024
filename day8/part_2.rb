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

def find_all_antinodes(row, col, row_step, col_step, grid_length, grid_width)
  antinodes = []
  loop do
    break unless in_bounds?(row, col, grid_length, grid_width)
    antinodes << [row, col]
    row += row_step
    col += col_step
  end
  antinodes
end

antinodes = Set.new

antennas_to_pos.each_value do |positions|
  positions.combination(2).each do |(first_row, first_col), (second_row, second_col)|
    row_diff = first_row - second_row
    col_diff = first_col - second_col

    # Find antinodes in both directions and merge them into the set
    antinodes.merge(find_all_antinodes(first_row, first_col, row_diff, col_diff, grid_length, grid_width))
    antinodes.merge(find_all_antinodes(second_row, second_col, -row_diff, -col_diff, grid_length, grid_width))
  end
end

puts antinodes.length