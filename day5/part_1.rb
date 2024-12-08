require 'set'

INPUT_FILENAME = 'input.txt'

reading_rules = true
invalid_entries_map = Hash.new { |hash, key| hash[key] = [] }
mid_page_sum = 0

def process_page_numbers(line, invalid_entries_map)
  invalid_entries = Set.new
  pages = line.split(',').map(&:to_i)
  pages.each do |page|
    return 0 if invalid_entries.include?(page)
    invalid_entries.merge(invalid_entries_map[page])
  end
  pages[pages.length/2]
end

File.foreach(INPUT_FILENAME) do |line|
  stripped_line = line.strip
  if stripped_line.empty?
    reading_rules = false
    next
  end

  if reading_rules
    rule_components = stripped_line.split('|').map(&:to_i)
    invalid_entries_map[rule_components[1]] << rule_components[0]
  else
    mid_page_sum += process_page_numbers(stripped_line, invalid_entries_map)
  end
end

puts(mid_page_sum)
