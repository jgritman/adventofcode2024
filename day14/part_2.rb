require 'set'

INPUT_FILENAME = 'input.txt'
ROOM_WIDTH = 101
ROOM_HEIGHT = 103

class Robot
  attr_accessor :x, :y, :velocity_x, :velocity_y

  def initialize(x, y, velocity_x, velocity_y)
    @x, @y, @velocity_x, @velocity_y = x, y, velocity_x, velocity_y
  end

  def move(seconds)
    @x = wrap_position(x + velocity_x * seconds, ROOM_WIDTH)
    @y = wrap_position(y + velocity_y * seconds, ROOM_HEIGHT)
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

def print_grid(robots, seconds)
  robot_positions = Set.new
  robots.each do |robot|
    position = [robot.y, robot.x]
    return if robot_positions.include?(position)  # Early exit if duplicate is found
    robot_positions << position
  end

  puts "Grid for #{seconds} seconds:"
  (0...ROOM_HEIGHT).each do |row|
    (0...ROOM_WIDTH).each { |col| print robot_positions.include?([row, col]) ? '*' : '.' }
    puts
  end
end

robots = []
File.foreach(INPUT_FILENAME) { |line| robots << Robot.new(*extract_numbers(line)) }

(1...10000).each do |i|
  robots.each { |robot| robot.move(1) }
  print_grid(robots, i)
end
