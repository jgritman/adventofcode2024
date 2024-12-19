require 'set'

INPUT_FILENAME = 'input.txt'

DIRECTIONS = [
  [-1,0], # up
  [0,1], # right
  [1, 0], # down
  [0,-1] # left
]

class Plot
  attr_accessor :plant_type, :area, :perimiter_map

  def initialize(plant_type)
    @plant_type = plant_type
    @area = 0
    @perimiter_map = Hash.new { |hash, key| hash[key] = [] }
  end

  def increment_area
    @area += 1
  end

  def append_permiter(row, col, direction)
    @perimiter_map[direction] << [row,col]
  end

  def cost
    @area * sides
  end

  private

  def sides
    @perimiter_map.sum do |direction, positions|
      if direction[0] == 0 # Horizontal sides (left/right)
        count_vertical_sides(positions)
      else # Vertical sides (up/down)
        count_horizontal_sides(positions)
      end
    end
  end

  def count_vertical_sides(positions)
    groups = positions.group_by { |_row, col| col }
    groups.values.sum { |group| count_gaps(group.map { |row, _col| row }) }
  end

  def count_horizontal_sides(positions)
    groups = positions.group_by { |row, _col| row }
    groups.values.sum { |group| count_gaps(group.map { |_row, col| col }) }
  end

  def count_gaps(sorted_values)
    sorted_values = sorted_values.sort
    prev = nil
    sorted_values.sum do |value|
      gap = (prev.nil? || value != prev + 1) ? 1 : 0
      prev = value
      gap
    end
  end
end

def in_bounds?(row, col, map_matrix)
  row.between?(0, map_matrix.length - 1) && col.between?(0, map_matrix[0].length - 1)
end

def visit(plot, garden_matrix, row, col, visited)
  return if visited.include?([row, col])

  visited << [row, col]
  plot.increment_area

  DIRECTIONS.each do |direction|
    adjacent_row, adjacent_col = row + direction[0], col + direction[1]
    if in_bounds?(adjacent_row, adjacent_col, garden_matrix) && garden_matrix[adjacent_row][adjacent_col] == plot.plant_type
      visit(plot, garden_matrix, adjacent_row, adjacent_col, visited)
    else
      plot.append_permiter(row, col, direction)
    end
  end
end

garden_matrix = File.readlines(INPUT_FILENAME).map { |line| line.strip.chars }

visited = Set.new
cost = 0

garden_matrix.each_with_index do |row, row_idx|
  row.each_with_index do |plant_type, col_idx|
    next if visited.include?([row_idx, col_idx])

    plot = Plot.new(plant_type)
    visit(plot, garden_matrix, row_idx, col_idx, visited)
    cost += plot.cost
  end
end

puts cost