INPUT = '0 7 6618216 26481 885 42 202642 8791'
ITERATIONS = 75

def split_sum(stone, blinks_remaining, cache)
  return 1 if blinks_remaining == 0

  cache_key = [stone, blinks_remaining]
  return cache[cache_key] if cache.key?(cache_key)

  # Subtract one from blinks_remaining for the next recursion
  new_blinks_remaining = blinks_remaining - 1
  result = 0

  if stone == 0
    result = split_sum(1, new_blinks_remaining, cache)
  else
    stone_string = stone.to_s
    if stone_string.length.even?
      # If the stone has an even number of digits, split it
      middle = stone_string.length / 2
      part_1 = stone_string[0...middle]
      part_2 = stone_string[middle..-1]
      result = split_sum(part_1.to_i, new_blinks_remaining, cache) +
               split_sum(part_2.to_i, new_blinks_remaining, cache)
    else
      # If odd, multiply the stone by 2024
      result = split_sum(stone * 2024, new_blinks_remaining, cache)
    end
  end

  # Memoize the result
  cache[cache_key] = result
  result
end

stones = INPUT.split.map(&:to_i)
cache = {}

stone_count = stones.sum { |stone| split_sum(stone, ITERATIONS, cache) }

puts stone_count
