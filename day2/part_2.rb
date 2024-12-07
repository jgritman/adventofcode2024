VALID_READING_RANGE = 1..3

def check_valid(readings, dampened = false)
  readings_asc = readings.first < readings.last
  readings.each_cons(2).with_index do |(prev, curr), idx|
    diff = (curr - prev) * (readings_asc ? 1 : -1)

    next if VALID_READING_RANGE.include?(diff)

    return false if dampened

    return [0,1].any? do |shift|
      dampended_list = readings.dup.tap { |r| r.delete_at(idx + shift) }
      check_valid(dampended_list, true)
    end
  end
  true
end

valid_count = File.foreach('input.txt').count do |line|
  check_valid(line.split.map(&:to_i))
end

puts valid_count