INPUT_FILENAME = 'input.txt'

ROBOT_CHAR = '@'
WALL_CHAR = '#'
BOX_CHAR = 'O'
SPACE_CHAR = '.'

DIRECTIONS = {
  '^' => [-1,0], # up
  '>' => [0,1], # right
  'v' => [1, 0], # down
  '<' => [0,-1] # left
}

# helper methods
def next_position(row, col, direction)
  [row + direction[0], col + direction[1]]
end

def move_boxes?(row, col, direction, map_matrix)
  target_row, target_col = next_position(row, col, direction)
  case map_matrix[target_row][target_col]
  when WALL_CHAR then false
  when BOX_CHAR then move_boxes?(target_row, target_col, direction, map_matrix)
  else
    map_matrix[target_row][target_col] = BOX_CHAR
    true
  end
end

def move_robot(map_matrix, robot_pos, target_row, target_col)
  map_matrix[robot_pos[0]][robot_pos[1]] = SPACE_CHAR
  map_matrix[target_row][target_col] = ROBOT_CHAR
  [target_row, target_col]
end

#read file
robot_pos = nil
map_matrix = []
reading_map = true
instructions = []

File.readlines(INPUT_FILENAME).each_with_index do |line, row_idx|
  stripped_line = line.strip.chars
  if stripped_line.empty?
    reading_map = false
    next
  end

  if reading_map
    robot_col = stripped_line.index(ROBOT_CHAR)
    robot_pos = [row_idx, robot_col] if robot_col
    map_matrix << stripped_line
  else
    instructions.concat(stripped_line)
  end
end

# process each instruction
instructions.each do |instruction|
  direction = DIRECTIONS[instruction]
  target_row, target_col = next_position(robot_pos[0], robot_pos[1], direction)

  case map_matrix[target_row][target_col]
  when WALL_CHAR then next
  when BOX_CHAR
    if move_boxes?(target_row, target_col, direction, map_matrix)
      robot_pos = move_robot(map_matrix, robot_pos, target_row, target_col)
    end
  else robot_pos = move_robot(map_matrix, robot_pos, target_row, target_col)
  end
end

# calculate a gps sum of all box positions
gps_sum = map_matrix.each_with_index.sum do |row, row_idx|
  row.each_with_index.sum do |char, col_idx|
    char == BOX_CHAR ? (100 * row_idx) + col_idx : 0
  end
end

puts gps_sum