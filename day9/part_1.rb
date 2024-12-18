INPUT_FILENAME = 'input.txt'

filesystem = []

File.open(INPUT_FILENAME) do |file|
  file.each_char.with_index do |char, idx|
    to_append = idx % 2 == 0 ? idx / 2 : nil
    char.to_i.times { filesystem << to_append }
  end
end

end_pos = filesystem.length - 1

filesystem.each_with_index do |file_id, idx|
  next if file_id # Skip non-empty positions

  # Find the next non-empty position from the end
  while filesystem[end_pos].nil? && end_pos > idx
    end_pos -= 1
  end

  break if end_pos < idx # If we've reached a point where no more swaps are possible

  # Swap elements
  filesystem[idx], filesystem[end_pos] = filesystem[end_pos], filesystem[idx]
end

checksum = 0

filesystem.each_with_index do |file_id, idx|
  break unless file_id
  checksum += file_id * idx
end

puts checksum