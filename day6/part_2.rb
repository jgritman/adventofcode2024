require 'set'

INPUT_FILENAME = 'input.txt'

GUARD_POS_CHAR = '^'
OBSTACLE_CHAR = '#'

UP, RIGHT, DOWN, LEFT = [[-1, 0], [0, 1], [1, 0], [0, -1]]
DIRECTIONS = [UP, RIGHT, DOWN, LEFT]

MovementStatus = Struct.new(:row, :col, :direction)

# Load the map and find the initial guard position
obstacles = Set.new
grid_length, grid_width = 0, 0
guard_start_position = nil

File.foreach(INPUT_FILENAME).with_index do |line, row_idx|
  stripped_line = line.strip
  next if stripped_line.empty?

  row_chars = stripped_line.chars
  grid_length += 1
  grid_width = row_chars.length

  guard_col = row_chars.index(GUARD_POS_CHAR)
  guard_start_position ||= [row_idx, guard_col] if guard_col

  # Mark any obstacles
  row_chars.each_with_index do |char, col_idx|
    obstacles << [row_idx, col_idx] if char == OBSTACLE_CHAR
  end
end

guard_start_movement = MovementStatus.new(*guard_start_position, 0)

def in_bounds?(row, col, grid_length, grid_width)
  row.between?(0, grid_length - 1) && col.between?(0, grid_width - 1)
end

def navigate_map(movement, obstacles)
  row, col, direction = movement.row, movement.col, movement.direction
  delta_row, delta_col = DIRECTIONS[direction]

  new_row, new_col = row + delta_row, col + delta_col

  # Change direction if an obstacle is encountered
  if obstacles.include?([new_row, new_col])
    new_direction = (direction + 1) % DIRECTIONS.length
    MovementStatus.new(row, col, new_direction)
  else
    MovementStatus.new(new_row, new_col, direction)
  end
end

def has_infinite_loop?(start_movement, obstacles, grid_length, grid_width)
  visited_states = Set.new
  current_movement = start_movement
  loop do
    return false unless in_bounds?(current_movement.row, current_movement.col, grid_length, grid_width)
    return true if visited_states.include?(current_movement)

    visited_states << current_movement
    current_movement = navigate_map(current_movement, obstacles)
  end
end

current_movement = guard_start_movement
checked_positions = Set.new
valid_obstacles = Set.new

loop do
  break unless in_bounds?(current_movement.row, current_movement.col, grid_length, grid_width)

  current_pos = [current_movement.row, current_movement.col]
  unless checked_positions.include?(current_pos) || current_pos == guard_start_position
    modified_obstacles = obstacles.dup.add(current_pos)

    if has_infinite_loop?(guard_start_movement, modified_obstacles, grid_length, grid_width)
      valid_obstacles << current_pos
    end

    checked_positions << current_pos
  end
  current_movement = navigate_map(current_movement, obstacles)
end

puts valid_obstacles.length
