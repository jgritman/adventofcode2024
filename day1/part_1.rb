list1_entries, list2_entries = [], []

File.foreach('input.txt') do |line|
  a, b = line.split.map(&:to_i)
  list1_entries << a
  list2_entries << b
end

list1_entries.sort!
list2_entries.sort!

result = list1_entries.zip(list2_entries).sum { |a, b| (a - b).abs }

puts result