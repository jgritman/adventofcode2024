INPUT_FILENAME = 'input.txt'

Button = Struct.new(:x, :y)

class Game
  attr_accessor :a_button, :b_button, :prize_x, :prize_y

  A_BUTTON_COST = 3
  B_BUTTON_COST = 1
  MAX_BUTTON_PUSHES = 100

  def initialize(a_button)
    @a_button = a_button
  end

  def minimum_game_cost
    find_solutions.map { |a_pushes, b_pushes|
      (a_pushes * A_BUTTON_COST) + (b_pushes * B_BUTTON_COST)
    }.min
  end

  private

  def find_solutions
    max_a_pushes = [@prize_x / @a_button.x, @prize_y / @a_button.y, MAX_BUTTON_PUSHES].min

    (1..max_a_pushes).each_with_object([]) do |a_pushes, solutions|
      b_pushes = calculate_b_pushes_for_x(a_pushes)
      next if b_pushes.nil?

      # check if we also solve for y
      if (@a_button.y * a_pushes + @b_button.y * b_pushes) == @prize_y
        solutions << [a_pushes, b_pushes]
      end
    end
  end

  def calculate_b_pushes_for_x(a_pushes)
    b_pushes = (@prize_x - a_pushes * @a_button.x).to_f / @b_button.x
    b_pushes.positive? && b_pushes == b_pushes.to_i ? b_pushes.to_i : nil
  end
end

def extract_x_y(line)
  line.scan(/-?\d+/).map(&:to_i)
end

current_game = nil
token_sum = 0

File.foreach(INPUT_FILENAME).with_index do |line, row_idx|
  case row_idx % 4
  when 0 # new game, a button
    current_game = Game.new(Button.new(*extract_x_y(line)))
  when 1 # b button
    current_game.b_button = Button.new(*extract_x_y(line))
  when 2 # results, calculate min cost (if any)
    current_game.prize_x, current_game.prize_y = extract_x_y(line)
    token_sum += current_game.minimum_game_cost || 0
  end
end

puts token_sum