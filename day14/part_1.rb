INPUT_FILENAME = 'input.txt'
ROOM_WIDTH = 101
ROOM_HEIGHT = 103
ELAPSED_SECONDS =100
QUADRANT_HORIZONTAL_SPLIT = ROOM_WIDTH / 2
QUADRANT_VERTICAL_SPLIT = ROOM_HEIGHT / 2

class Robot
  attr_accessor :x, :y, :velocity_x, :velocity_y

  def initialize(x, y, velocity_x, velocity_y)
    @x, @y, @velocity_x, @velocity_y = x, y, velocity_x, velocity_y
  end

  def move(seconds)
    @x = wrap_position(x + velocity_x * seconds, ROOM_WIDTH)
    @y = wrap_position(y + velocity_y * seconds, ROOM_HEIGHT)
  end

  def quadrant
    return nil if @x == QUADRANT_HORIZONTAL_SPLIT || @y == QUADRANT_VERTICAL_SPLIT

    left = @x < QUADRANT_HORIZONTAL_SPLIT
    upper = @y < QUADRANT_VERTICAL_SPLIT

    case [left, upper]
    when [true, true]   then 0
    when [false, true]  then 1
    when [true, false]  then 2
    when [false, false] then 3
    end
  end

  private

  def wrap_position(position, limit)
    position %= limit
    position >= 0 ? position : position + limit
  end
end

def extract_numbers(line)
  line.scan(/-?\d+/).map(&:to_i)
end

quadrant_counts = Array.new(4, 0)

File.foreach(INPUT_FILENAME).with_index do |line|
  robot = Robot.new(*extract_numbers(line))
  robot.move(ELAPSED_SECONDS)
  quadrant = robot.quadrant
  quadrant_counts[quadrant] += 1 if quadrant
end

puts quadrant_counts.reduce(1, :*)