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
  
  def initialize()
    @root = nil
    @size = 0
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
          if parent.left == nil
            parent.left = node
            break
          else
            parent = parent.left
          end
        else # data > node.value
          if parent.right == nil
            parent.right = node
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

  # Breadth-first search using iteration with a queue.
  def breadth_first_search
  end

  # Depth-first search using iteration with a stack.
  def depth_first_search
  end

  # Depth-first search using recursion.
  def dfs_rec
  end

  # Returns a string representation of this binary tree.
  def to_s(node = @root, prefix = "", left_side = true)
    string = ""

    if node.right != nil
      string += to_s(node.right, prefix + (left_side ? "│   " : "    "), false)
    end

    string += prefix + (left_side ? "└── " : "┌── ") + node.value.to_s + "\n"

    if node.left != nil
      string += to_s(node.left, prefix + (left_side ? "    " : "│   "), true)
    end
    
    string
  end
  alias :inspect :to_s
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd
  
  tree = BinaryTree.new
  tree.build_tree((1..9).to_a)
  p tree

  tree2 = BinaryTree.new
  tree2.build_tree(%w[one two three four five six seven eight nine])
  p tree2
end
