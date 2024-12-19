INPUT_FILENAME = 'input.txt'
PRIZE_MODIFIER = 10000000000000

Button = Struct.new(:x, :y)

class Game
  attr_accessor :a_button, :b_button, :prize_x, :prize_y

  A_BUTTON_COST = 3
  B_BUTTON_COST = 1

  def initialize(a_button)
    @a_button = a_button
  end

  def minimum_game_cost
    # solve for one set of pushes
    # subsitute into the other then solve for that constant
    determinant = @a_button.y * @b_button.x - @b_button.y * @a_button.x
    return 0 if determinant == 0 # No solution or infinite solutions

    # Calculate a pushes
    numerator_a_pushes = @prize_y * @b_button.x - @b_button.y * @prize_x
    return 0 unless numerator_a_pushes % determinant == 0 # Ensure numerator_a_pushes is an integer
    a_pushes = numerator_a_pushes / determinant

    # Calculate b pushes
    numerator_b_pushes = @prize_x - @a_button.x * a_pushes
    return 0 unless numerator_b_pushes % @b_button.x == 0 # Ensure numerator_b_pushes is an integer
    b_pushes = numerator_b_pushes / @b_button.x

    # Ensure pushes are positive
    return 0 if a_pushes <= 0 || b_pushes <= 0

    (a_pushes * A_BUTTON_COST) + (b_pushes * B_BUTTON_COST)
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
    prize_x, prize_y = extract_x_y(line)
    current_game.prize_x, current_game.prize_y = prize_x + PRIZE_MODIFIER, prize_y + PRIZE_MODIFIER
    token_sum += current_game.minimum_game_cost || 0
  end
end

puts token_sum
