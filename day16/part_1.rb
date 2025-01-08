require 'set'

INPUT_FILENAME = 'input.txt'

# Constants for the maze
START_CHAR = 'S'
END_CHAR = 'E'
WALL_CHAR = '#'
PATH_CHAR = '.'

DIRECTIONS = [
  [-1,0], # up
  [0,1], # right
  [1, 0], # down
  [0,-1] # left
]

START_DIRECTION = DIRECTIONS[1] # 'east'

class PriorityQueue
  def initialize
    @queue = []
  end

  def push(item)
    @queue.push(item)
    @queue.sort_by! { |x| x[0] } # Sort by cost
  end

  def pop
    @queue.shift
  end

  def empty?
    @queue.empty?
  end
end

class Maze
  MazeMove = Struct.new(:row, :col, :direction)

  def initialize
    @maze_matrix = []
    @min_score = nil
  end

  def add_row(chars, row_idx)
    return if chars.empty?
    @maze_matrix << chars
    start_col = chars.index(START_CHAR)
    @start_pos = [row_idx, start_col] if start_col
    end_col = chars.index(END_CHAR)
    @end_pos = [row_idx, end_col] if end_col
  end

  def solve
    rows = @maze_matrix.size
    cols = @maze_matrix[0].size

    # Priority queue for Dijkstra's algorithm: [cost, position, direction]
    pq = PriorityQueue.new
    pq.push([0, @start_pos, START_DIRECTION]) # [cost, [row, col], direction]

    # Visited set to avoid re-processing nodes
    visited = Set.new

    min_score = nil

    until pq.empty?
      current_cost, (current_row, current_col), current_direction = pq.pop

      # Skip if already visited
      next if visited.include?([current_row, current_col, current_direction])

      # Mark as visited
      visited.add([current_row, current_col, current_direction])

      # Check if we've reached the end position
      if [current_row, current_col] == @end_pos
        min_score = current_cost if min_score.nil? || current_cost < min_score
        next # Continue exploring to find all solutions
      end

      # Explore neighbors
      DIRECTIONS.each do |direction|
        next_row = current_row + direction[0]
        next_col = current_col + direction[1]

        next if @maze_matrix[next_row][next_col] == "#"

        # Calculate the cost to move to the next cell
        direction_change_cost = direction_change(current_direction, direction) * 1000
        next_cost = current_cost + 1 + direction_change_cost

        # Add to the priority queue
        pq.push([next_cost, [next_row, next_col], direction])
      end
    end

    min_score
  end

  def direction_change(old_direction, new_direction)
    return 0 if old_direction == new_direction
    return 2 if old_direction[0] == new_direction[0] || old_direction[1] == new_direction[1]
    1
  end
end

maze = Maze.new

File.readlines(INPUT_FILENAME).each_with_index do |line, row_idx|
  maze.add_row(line.strip.chars, row_idx)
end

puts maze.solve

