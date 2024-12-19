INPUT = '0 7 6618216 26481 885 42 202642 8791'

def split_stone(stone_string)
  middle = stone_string.length / 2
  part1 = stone_string[0...middle]
  part2 = stone_string[middle..-1]
  [part1.to_i, part2.to_i]
end

def handle_blink(stones)
  stones.flat_map do |stone|
    next 1 if stone == 0
    stone_string = stone.to_s
    stone_string.length % 2 == 0 ? split_stone(stone_string) : stone * 2024
  end
end

stones = INPUT.split.map(&:to_i)

25.times { stones = handle_blink(stones) }

puts stones.size