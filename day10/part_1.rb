INPUT_FILENAME = 'input.txt'

DIRECTIONS = [
  [-1,0], # up
  [0,1], # right
  [1, 0], # down
  [0,-1] # left
]

TRAILHEAD = 0
DESTINATION_HEIGHT = 9

# Load the map and mark trailheads
map_matrix = []
trailheads = []

File.foreach(INPUT_FILENAME).with_index do |line, row_idx|
  stripped_line = line.strip
  next if stripped_line.empty?

  heights = stripped_line.chars.map(&:to_i)
  trailheads += heights.each_index.select { |col_idx| heights[col_idx] == TRAILHEAD }
                                  .map { |col_idx| [row_idx, col_idx] }

  map_matrix << heights
end

# Helper to check if a position is within bounds of the map
def in_bounds?(row, col, map_matrix)
  row.between?(0, map_matrix.length - 1) && col.between?(0, map_matrix[0].length - 1)
end

# Recursive function to visit positions and find paths
def visit_position(row, col, map_matrix, visited_heights)
  # Return cached result if already visited
  return visited_heights[[row, col]] if visited_heights.key?([row, col])

  current_height = map_matrix[row][col]

  # Explore all valid directions
  end_positions = DIRECTIONS.flat_map do |row_change, col_change|
    new_row, new_col = row + row_change, col + col_change

    next [] unless in_bounds?(new_row, new_col, map_matrix)

    new_height = map_matrix[new_row][new_col]
    next [] unless new_height - current_height == 1

    new_height == DESTINATION_HEIGHT ? [[new_row, new_col]] : visit_position(new_row, new_col, map_matrix, visited_heights)
  end
  results = end_positions.uniq
  visited_heights[[row, col]] = results
  results
end

visited_heights = {}

result = trailheads.sum do |trailhead_row, trailhead_col|
  visit_position(trailhead_row, trailhead_col, map_matrix, visited_heights).size
end

puts result
