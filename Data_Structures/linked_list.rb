#!/usr/bin/env ruby

class Node
  attr_accessor :value, :next
  
  def initialize(value = nil)
    @value = value
    @next = nil
  end
end

class LinkedList
  def initialize
    @head = nil
    @tail = nil
    @size = 0
  end

  # Adds the specified data to the end of the list.
  # Returns the list itself, so several appends may be chained together.
  def append(data)
    node = Node.new(data)

    if size == 0
      @head = node
    else
      @tail.next = node
    end

    @tail = node
    @size += 1
    self
  end
  alias :push :append

  # Adds the specified data to the front of the list.
  # Returns the list itself, so several prepends may be chained together.
  def prepend(data)
    node = Node.new(data)

    if size == 0
      @tail = node
    else
      node.next = @head
    end

    @head = node
    @size += 1
    self
  end
  alias :unshift :prepend

  # Returns the number of elements in the list.
  def size
    @size
  end
  alias :length :size

  # Returns the first element in the list.
  def head
    @head == nil ? nil : @head.value
  end
  alias :first :head

  def tail
    @tail == nil ? nil : @tail.value
  end
  alias :last :tail

  # Returns the element at the specified index.
  def at(index)
    return nil if index >= @size || index <= -@size
    index += @size if index < 0
    node = @head
    index.times { node = node.next }
    node.value
  end

  # Removes the last element from the list and returns it.
  def pop
    if size == 0
      data = nil
    else
      node = @head
      node = node.next until node.next == @tail
      @tail = node
      data = node.next.value
      node.next = nil
      @size -= 1
    end
    data
  end

  # Returns true if the specified data is in the list; false otherwise.
  def contains?(data)
    node = @head
    @size.times do
      return true if node.value == data
      node = node.next
    end
    false
  end

  # Returns the index of the element that contains the specified data,
  # or nil if not found.
  def find(data)
    node = @head
    index = 0
    @size.times do
      return index if node.value == data
      index += 1
      node = node.next
    end
    nil
  end

  # The format should be: ( data ) -> ( data ) -> ( data ) -> nil
  def to_s
    string = ""
    node = @head
    @size.times do
      string << "( #{node.value} ) -> "
      node = node.next
    end
    string << "nil"
  end

  # Adds the specified data at the specified index in the list
  def insert_at(data, index)
  end

  # Removes the element at the specified index. Returns the element.
  def remove_at(index)
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd

  list = LinkedList.new
  failed = []
  failed << 1 if list.size != 0
  failed << 2 if list.head != nil
  failed << 3 if list.tail != nil
  failed << 4 if list.to_s != "nil"
  list.append(1)
  failed << 3 if list.size != 1
  failed << 4 if list.head != 1
  failed << 5 if list.tail != 1
  failed << 6 if list.to_s != "( 1 ) -> nil"
  list.push(2).append(3)
  failed << 7 if list.size != 3
  failed << 8 if list.head != 1
  failed << 9 if list.tail != 3
  failed << 10 if list.to_s != "( 1 ) -> ( 2 ) -> ( 3 ) -> nil"
  list.prepend(0)
  failed << 11 if list.length != 4
  failed << 12 if list.first != 0
  failed << 13 if list.last != 3
  failed << 14 if list.to_s != "( 0 ) -> ( 1 ) -> ( 2 ) -> ( 3 ) -> nil"
  list.unshift(-1).prepend(-2)
  failed << 15 if list.length != 6
  failed << 16 if list.first != -2
  failed << 17 if list.last != 3
  failed << 18 if list.to_s != "( -2 ) -> ( -1 ) -> ( 0 ) -> ( 1 ) -> ( 2 ) -> ( 3 ) -> nil"
  failed << 19 if list.at(0) != -2
  failed << 20 if list.at(2) != 0
  failed << 21 if list.at(-1) != 3
  failed << 22 if list.at(-3) != 1
  failed << 23 if !list.contains?(-1)
  failed << 24 if list.contains?(4)
  failed << 25 if list.find(-1) != 1
  failed << 26 if list.find(2) != 4
  failed << 27 if list.pop != 3
  failed << 28 if list.size != 5
  failed << 29 if list.head != -2
  failed << 30 if list.tail != 2
  list.pop
  list.pop
  list.pop
  list.append("foo")
  list.append(2.34)
  list.append([1,2,3])
  failed << 31 if list.to_s != "( -2 ) -> ( -1 ) -> ( foo ) -> ( 2.34 ) -> ( [1, 2, 3] ) -> nil"
  failed << 32 if list.pop != [1, 2, 3]
  failed << 33 if list.pop != 2.34
  failed << 34 if list.pop != "foo"

  if failed.length == 0
    puts "All tests passed"
  else
    puts "Failed tests: #{failed}"
  end
end