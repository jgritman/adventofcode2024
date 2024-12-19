INPUT_FILENAME = 'input.txt'

class DiskBlock
  attr_accessor :file_id, :size, :prev, :next

  def initialize(file_id, size)
    @file_id = file_id
    @size = size
  end
end

class Filesystem
  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  # Add a new node to the end of the list
  def append(new_node)
    if @tail
      @tail.next = new_node
      new_node.prev = @tail
    else
      @head = new_node
    end
    @tail = new_node
  end

  def insert_after(node, new_file_id, new_size)
    return unless node # Do nothing if the given node is `nil`

    new_node = DiskBlock.new(new_file_id, new_size)

    # Set the links for the new node
    new_node.next = node.next
    new_node.prev = node

    # Update the current node's next pointer
    node.next = new_node

    # Update the next node's previous pointer, if it exists
    new_node.next.prev = new_node if new_node.next

    # If we're inserting after the tail, update the tail reference
    @tail = new_node if node == @tail
  end

  def replace(node, new_file_id, new_size)
    return unless node # Do nothing if the given node is `nil`

    new_node = DiskBlock.new(new_file_id, new_size)

    # Update links of the previous node
    if node.prev
      node.prev.next = new_node
      new_node.prev = node.prev
    else
      @head = new_node # If replacing the head, update the head reference
    end

    # Update links of the next node
    if node.next
      node.next.prev = new_node
      new_node.next = node.next
    else
      @tail = new_node # If replacing the tail, update the tail reference
    end

    # Old node is effectively removed by breaking its links
    node.next = nil
    node.prev = nil

    new_node
  end

  def print_blocks
    current = @head
    while current
      print (current.file_id || '.').to_s * current.size
      current = current.next
    end
    puts
  end

  def checksum
    current = @head
    checksum_val = 0
    position = 0

    while current
      current.size.times do
        checksum_val += position * current.file_id if current.file_id
        position += 1
      end
      current = current.next
    end

    checksum_val
  end
end

filesystem = Filesystem.new

# Read and populate the filesystem
File.open(INPUT_FILENAME) do |file|
  file.each_char.with_index do |char, idx|
    size = char.to_i
    next if size.zero? # Skip empty blocks

    file_id = (idx.even? ? idx / 2 : nil)
    filesystem.append(DiskBlock.new(file_id, size))
  end
end

def move_file(filesystem, to_move)
  file_size = to_move.size
  current = filesystem.head

  while current != to_move
    if !current.file_id && current.size >= file_size
      remaining = current.size - file_size

      new_node = filesystem.replace(current, to_move.file_id, file_size)
      replacement_node = filesystem.replace(to_move, nil, file_size)

      #add the remaining free space if we didn't use it all up
      filesystem.insert_after(new_node, nil, remaining) if remaining.positive?

      return replacement_node
    end
    current = current.next
  end
  to_move
end

current_file_number = filesystem.tail.file_id # only process what hasn't been moved yet
current = filesystem.tail

while current != filesystem.head
  if current.file_id && current.file_id <= current_file_number
    current_file_number = current.file_id
    current = move_file(filesystem, current)
  end
  current = current.prev
end

puts filesystem.checksum