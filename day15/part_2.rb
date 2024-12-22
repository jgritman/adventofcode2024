INPUT_FILENAME = 'input.txt'

ROBOT_CHAR = '@'
WALL_CHAR = '#'
BOX_CHAR = 'O'
BOX_LEFT_CHAR = '['
BOX_RIGHT_CHAR = ']'
SPACE_CHAR = '.'

DIRECTIONS = {
  '^' => [-1,0], # up
  '>' => [0,1], # right
  'v' => [1, 0], # down
  '<' => [0,-1] # left
}

class WarehouseMap

  def initialize()
    @map_matrix = []
  end

  def add_row(chars, row_idx)
    row = chars.each_with_index.flat_map do |char, col_idx|
      case char
      when BOX_CHAR
        [BOX_LEFT_CHAR, BOX_RIGHT_CHAR]
      when ROBOT_CHAR
        @robot_row, @robot_col = row_idx, col_idx * 2
        [ROBOT_CHAR, SPACE_CHAR]
      else
        [char, char]
      end
    end
    @map_matrix << row
  end

  def gps_sum
    @map_matrix.each_with_index.sum do |row, row_idx|
      row.each_with_index.sum do |char, col_idx|
        char == BOX_LEFT_CHAR ? (100 * row_idx) + col_idx : 0
      end
    end
  end

  def process_robot_instruction(instruction)
    direction = DIRECTIONS[instruction]
    target_row, target_col = next_position(@robot_row, @robot_col, direction)

    case @map_matrix[target_row][target_col]
    when WALL_CHAR
      return
    when BOX_LEFT_CHAR, BOX_RIGHT_CHAR
      move_robot(target_row, target_col) if move_boxes?(target_row, target_col, direction)
    else
      move_robot(target_row, target_col)
    end
  end

  def print_map
    @map_matrix.each { |row| puts row.join }
  end

  private
  def next_position(row, col, direction)
    [row + direction[0], col + direction[1]]
  end

  def move_boxes?(row, col, direction)
    boxes_to_move = []
    movable = false
    if direction[0] == 0
      movable = move_boxes_horizontal?(row, col, direction[1], boxes_to_move)
    else
      movable = move_boxes_vertial?(row, col, direction, boxes_to_move)
      boxes_to_move = boxes_to_move.uniq.sort do |box_a, box_b|
        (box_b[0] <=> box_a[0]) * -direction[0]
      end
    end
    return false unless movable

    boxes_to_move.reverse_each do |box_pos|
      box_char = @map_matrix[box_pos[0]][box_pos[1]]
      new_row, new_col = box_pos[0] + direction[0], box_pos[1] + direction[1]
      @map_matrix[new_row][new_col] = box_char
      @map_matrix[box_pos[0]][box_pos[1]] = SPACE_CHAR
    end
  end

  def move_boxes_horizontal?(row, col, col_shift, boxes_to_move)
    boxes_to_move << [row, col]
    boxes_to_move << [row, col + (col_shift)]
    target_col = col + (col_shift * 2)
    case @map_matrix[row][target_col]
    when WALL_CHAR then return false
    when BOX_LEFT_CHAR, BOX_RIGHT_CHAR then move_boxes_horizontal?(row, target_col, col_shift, boxes_to_move)
    else true
    end
  end

  def move_boxes_vertial?(row, col, direction, boxes_to_move, paired = false)
    boxes_to_move << [row, col]
    box_char = @map_matrix[row][col]
    pair_shift = box_char == BOX_LEFT_CHAR ? 1 : -1
    target_row = row + direction[0]

    case @map_matrix[target_row][col]
    when WALL_CHAR
      false
    when BOX_LEFT_CHAR, BOX_RIGHT_CHAR
      if paired
        # Go to the next row if alredy paired
        move_boxes_vertial?(target_row, col, direction, boxes_to_move)
      else
        # Check next row and other box pair
        move_boxes_vertial?(row, col + pair_shift, direction, boxes_to_move, true) &&
             move_boxes_vertial?(target_row, col, direction, boxes_to_move)
      end
    else # space
      paired || move_boxes_vertial?(row, col + pair_shift, direction, boxes_to_move, true)
    end
  end

  def move_robot(target_row, target_col)
    @map_matrix[@robot_row][@robot_col] = SPACE_CHAR
    @map_matrix[target_row][target_col] = ROBOT_CHAR
    @robot_row, @robot_col = target_row, target_col
  end
end

#read file
reading_map = true
instructions = []
map = WarehouseMap.new

File.readlines(INPUT_FILENAME).each_with_index do |line, row_idx|
  stripped_line = line.strip.chars
  if stripped_line.empty?
    reading_map = false
    next
  end

  if reading_map
    map.add_row(stripped_line, row_idx)
  else
    instructions.concat(stripped_line)
  end
end


# process each instruction
instructions.each_with_index do |instruction, step|
  map.process_robot_instruction(instruction)
end

puts map.gps_sum