VALID_READING_RANGE = 1..3

def check_valid(readings)
  readings_asc = readings.first < readings.last
  readings.each_cons(2).all? do |prev, curr|
    diff = (curr - prev) * (readings_asc ? 1 : -1)
    VALID_READING_RANGE.include?(diff)
  end
end

valid_count = File.foreach('input.txt').count do |line|
  check_valid(line.split.map(&:to_i))
end

puts valid_count