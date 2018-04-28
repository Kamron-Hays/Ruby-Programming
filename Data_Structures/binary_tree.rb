#!/usr/bin/env ruby

class Node
  attr_accessor :value, :parent, :left, :right
  
  def initialize(value = nil)
    @value = value
    @parent = nil
    @left = nil
    @right = nil
  end
end

class BinaryTree
	attr_reader :root, :size
  
  def initialize(debug = false)
    @root = nil
    @size = 0
    @list = [] # used as a queue or stack for searches
    @debug = debug
  end

  # Inserts the specified data into this binary tree.
  def insert(data)
    node = Node.new(data)

    if @size == 0
      @root = node
    else
      parent = @root

      loop do
        if data <= parent.value
          if !parent.left # found a leaf node
            parent.left = node # insert here
            break
          else
            parent = parent.left
          end
        else # data > node.value
          if !parent.right # found a leaf node
            parent.right = node # insert here
            break
          else
            parent = parent.right
          end
        end
      end
    end

    @size += 1
  end

  # Inserts the values in the specified array into this binary tree.
  def build_tree(ary)
    # If the array is sorted, the tree will not be balanced
    ary.shuffle!
    ary.each { |item| insert(item) }
  end
  
  # Searches this binary tree for the specified data using breadth-first
  # traversal. Returns the node at which the specified data is located,
  # or nil if it is not found.
  def breadth_first_search(data)
    node = nil
    @list << @root if @root

    until @list.empty?
      # get next node from the queue
      node = @list.shift
      puts "Visiting node #{node.value}" if @debug
      break if node.value == data
      # place each child in the queue, from left to right
      @list << node.left if node.left
      @list << node.right if node.right
    end
    @list.clear # remove any remaining items from the queue
	  node
  end

  # Searches this binary tree for the specified data using depth-first
  # preorder (root-left-right) traversal. Other options (not implemented)
  # are inorder (left-root-right) or postorder (left-right-root).
  # Returns the node at which the specified data is located, or nil if
  # it is not found.
  def depth_first_search(data)
    node = nil
    @list << @root if @root

    until @list.empty?
      # Get next node from the stack
      node = @list.pop
      puts "Visiting node #{node.value}" if @debug
      break if node.value == data
      # Push each child on the stack, making sure the left child
      # will be popped off the stack first (LIFO)
      @list << node.right if node.right
      @list << node.left if node.left
    end
    @list.clear # remove any remaining items from the stack
	  node
  end

  # Searches this binary tree for the specified data using depth-first
  # preorder traversal and recursion.
  def dfs_rec(data, node = @root)
    if node
      puts "Visiting node #{node.value}" if @debug
      if data != node.value
        left = dfs_rec(data, node.left)
        if !left
          node = dfs_rec(data, node.right)
        else
          node = left
        end
      end
    end
    node
  end

  # Returns the size of this binary tree.
  def size
    @size
  end

  # Returns a string representation of this binary tree.
  def to_s(node = @root, prefix = "", left_side = true)
    string = ""

    if node.right
      string += to_s(node.right, prefix + (left_side ? "│   " : "    "), false)
    end

    string += prefix + (left_side ? "└── " : "┌── ") + node.value.to_s + "\n"

    if node.left
      string += to_s(node.left, prefix + (left_side ? "    " : "│   "), true)
    end
    
    string
  end
  alias :inspect :to_s
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd

  debug = false
  tree = BinaryTree.new(debug)
  tree.build_tree((1..100).to_a)
  p tree if debug
  p tree.size == 100
  p tree.breadth_first_search(5).value == 5
  p tree.depth_first_search(5).value == 5
  p tree.dfs_rec(5).value == 5

  tree2 = BinaryTree.new(debug)
  tree2.build_tree(%w[one two three four five six seven eight nine])
  p tree2 if debug
  p tree2.breadth_first_search("five").value == "five"
  p tree2.depth_first_search("five").value == "five"
  p tree2.dfs_rec("five").value == "five"
  
  tree3 = BinaryTree.new(debug)
  tree3.build_tree([1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9])
  p tree3 if debug
  p tree.breadth_first_search(5).value == 5
  p tree.depth_first_search(5).value == 5
  p tree.dfs_rec(5).value == 5
end
