require 'set'

INPUT_FILENAME = 'input.txt'

DIRECTIONS = [
  [-1,0], # up
  [0,1], # right
  [1, 0], # down
  [0,-1] # left
]

class Plot
  attr_accessor :plant_type, :area, :perimiter

  def initialize(plant_type)
    @plant_type = plant_type
    @area = 0
    @perimiter = 0
  end

  def append_with_permiter(perimiter)
    @area += 1
    @perimiter += perimiter
  end

  def cost
    @area * @perimiter
  end
end

def in_bounds?(row, col, map_matrix)
  row.between?(0, map_matrix.length - 1) && col.between?(0, map_matrix[0].length - 1)
end

def visit(plot, garden_matrix, row, col, visited)
  return if visited.include?([row, col])

  visited << [row, col]
  permiter_count = 0

  DIRECTIONS.each do |direction|
    adjacent_row, adjacent_col = row + direction[0], col + direction[1]
    if in_bounds?(adjacent_row, adjacent_col, garden_matrix) && garden_matrix[adjacent_row][adjacent_col] == plot.plant_type
      visit(plot, garden_matrix, adjacent_row, adjacent_col, visited)
    else
      permiter_count += 1
    end
  end
  plot.append_with_permiter(permiter_count)
end

garden_matrix = File.readlines(INPUT_FILENAME).map do |line|
  line.strip.chars
end

visited = Set.new
plots = []

garden_matrix.each_with_index do |row, row_idx|
  row.each_with_index do |plant_type, col_idx|
    next if visited.include?([row_idx, col_idx])

    plot = Plot.new(plant_type)
    visit(plot, garden_matrix, row_idx, col_idx, visited)
    plots << plot
  end
end

cost = plots.sum(&:cost)

puts cost