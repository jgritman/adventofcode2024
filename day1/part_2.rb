list1_entries, list2_entries = [], []

File.foreach('input.txt') do |line|
  a, b = line.split.map(&:to_i)
  list1_entries << a
  list2_entries << b
end

result = list1_entries.sum { |num| num * list2_entries.count(num) }

puts result