INPUT_FILENAME = 'input.txt'

def process_page_numbers(pages, invalid_entries_map, modified = false)
  invalid_page_positions = {}

  pages.each_with_index do |page, idx|
    # If the page is already marked as invalid, swap and reprocess
    if invalid_page_positions.include?(page)
      swap_idx = invalid_page_positions[page]
      pages[idx], pages[swap_idx] = pages[swap_idx], pages[idx]
      return process_page_numbers(pages, invalid_entries_map, true)
    end

    # Mark invalid pages and their first occurrence index
    invalid_entries_map[page].each do |invalid_page|
      invalid_page_positions[invalid_page] ||= idx
    end
  end

  # Return the middle page if modified, otherwise 0
  modified ? pages[pages.length / 2] : 0
end

reading_rules = true
invalid_entries_map = Hash.new { |hash, key| hash[key] = [] }
mid_page_sum = 0

File.foreach(INPUT_FILENAME) do |line|
  stripped_line = line.strip

  if stripped_line.empty?
    reading_rules = false
    next
  end

  if reading_rules
    rule_prev, rule_after = stripped_line.split('|').map(&:to_i)
    invalid_entries_map[rule_after] << rule_prev
  else
    pages = stripped_line.split(',').map(&:to_i)
    mid_page_sum += process_page_numbers(pages, invalid_entries_map)
  end
end

puts(mid_page_sum)
