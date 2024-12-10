require 'set'

INPUT_FILENAME = 'input.txt'

GUARD_POS_CHAR = '^'
OBSTACLE_CHAR = '#'

DIRECTIONS = [
  [-1,0], # up
  [0,1], # right
  [1, 0], # down
  [0,-1] # left
]

# Load the map and find the initial guard position
map_matrix = []
guard_row, guard_col = nil, nil

File.foreach(INPUT_FILENAME).with_index do |line, row_idx|
  stripped_line = line.strip
  next if stripped_line.empty?

  row_chars = stripped_line.chars
  guard_position = row_chars.index(GUARD_POS_CHAR)

  # Set guard position if found
  if guard_position
    guard_row, guard_col = row_idx, guard_position
  end

  map_matrix << row_chars
end

current_direction_idx = 0
visited_locations = Set.new

loop do
  visited_locations << [guard_row, guard_col]
  current_direction = DIRECTIONS[current_direction_idx]

  # Calculate the next position
  new_guard_row = guard_row + current_direction[0]
  new_guard_col = guard_col + current_direction[1]

  # Break if the next position is out of bounds
  break unless new_guard_row.between?(0, map_matrix.length - 1) &&
               new_guard_col.between?(0, map_matrix[0].length - 1)

  # Change direction if an obstacle is encountered
  if map_matrix[new_guard_row][new_guard_col] == OBSTACLE_CHAR
    current_direction_idx = (current_direction_idx + 1) % DIRECTIONS.length
  else
    # Move to the next position
    guard_row, guard_col = new_guard_row, new_guard_col
  end
end

puts visited_locations.length