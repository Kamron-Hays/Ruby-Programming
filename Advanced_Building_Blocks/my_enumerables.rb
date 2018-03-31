#!/usr/bin/env ruby

module Enumerable
  def my_each
    return to_enum(__method__) if !block_given?
    for item in self do
      yield(item)
    end
  end
  
  def my_each_with_index
    return to_enum(__method__) if !block_given?
    self.size.times { |i| yield(self[i], i) }
  end

  # Returns an array containing all elements of enum for which the given block
  # returns a true value. If no block is given, an Enumerator is returned instead.
  # Same as #find_all
  def my_select
    return to_enum(__method__) if !block_given?
    arr = []
    self.my_each { |item| arr << item if yield(item) }
    arr
  end
  alias :my_find_all :my_select

  # Passes each element of the collection to the given block. The method returns
  # true if the block never returns false or nil. If the block is not given, Ruby
  # adds an implicit block of { |obj| obj } which will cause all? to return true
  # when none of the collection members are false or nil.
  def my_all?
    if block_given?
      self.my_each { |item| return false if !yield(item) }
    else
      self.my_each { |item| return false if !item }
    end
    true
  end

  # Passes each element of the collection to the given block. The method returns
  # true if the block never returns true for all elements. If the block is not
  # given, none? will return true only if none of the collection members is true.
  def my_none?
    if block_given?
      self.my_each { |item| return false if yield(item) }
    else
      self.my_each { |item| return false if item }
    end
    true
  end

  # Passes each element of the collection to the given block. The method returns
  # true if the block ever returns a value other than false or nil. If the block
  # is not given, Ruby adds an implicit block of { |obj| obj } that will cause
  # any? to return true if at least one of the collection members is not false or
  # nil.
  def my_any?(&block)
    !self.my_none?(&block)
  end
  
  # Returns the number of items in enum through enumeration. If an argument is
  # given, the number of items in enum that are equal to item are counted. If a
  # block is given, it counts the number of elements yielding a true value.
  def my_count(item=nil)
    if block_given?
      count=0
		  self.my_each { |x| count += 1 if yield(x) }
      return count
    else
      if item == nil
        return self.size
      else
        return self.my_count { |x| x == item }
      end
    end
  end

  # Returns a new array with the results of running block once for every element
  # in enum. If no block is given, an enumerator is returned instead.
  # Same as #collect
  def my_map
    return to_enum(__method__) if !block_given?
    arr = []
    self.my_each { |item| arr << yield(item) }
    arr
  end
  alias :my_collect :my_map

  # Combines all elements of enum by applying a binary operation, specified by a
  # block or a symbol that names a method or operator.
  #
  # If you specify a block, then for each element in enum the block is passed an
  # accumulator value (memo) and the element. If you specify a symbol instead,
  # then each element in the collection will be passed to the named method of
  # memo. In either case, the result becomes the new value for memo. At the end
  # of the iteration, the final value of memo is the return value for the method.
  #
  # If you do not explicitly specify an initial value for memo, then the first
  # element of collection is used as the initial value of memo.
  # Same as #reduce
  def my_inject(memo=nil,symbol=nil)
    if symbol != nil
      self.my_each { |item| memo = memo.send(symbol, item) }
    else
      if memo != nil && memo.class == Symbol
        symbol, memo = memo, self.first
        self.drop(1).my_each { |item| memo = memo.send(symbol, item) }
      else
        if memo == nil
          memo = self.first
          enum = self.drop(1)
        else
          enum = self
        end
        enum.my_each { |item| memo = yield(memo, item) }
      end
    end
    memo
  end
  alias :my_reduce :my_inject
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd

  arr = []
  [1,2,3].my_each { |item| arr << item + 3 }
  p arr == [4,5,6]
  
  arr = []
  {banana: "fruit", hamburger: "meat", carrot: "vegetable"}.my_each { |key,value| arr << key.to_s + " is a " + value }
  p arr == ["banana is a fruit", "hamburger is a meat", "carrot is a vegetable"]
  
  arr = []
  [1,2,3].my_each_with_index { |item, i| arr << item * i }
  p arr == [0,2,6]
  
  p [1,2,3,4,5,6].my_select { |item| item.even? } == [2,4,6]
  p (1..6).my_find_all { |item| item.even? } == [2,4,6]
  
  p [1,2,3].my_all? { |item| item < 4 } == true
  p [1,2,3].my_all? { |item| item < 3 } == false
  p [0,1,2].my_all? == true
  p [nil, true, 99].my_all? == false
  
  p [1,2,3].my_any? { |item| item == 2 } == true
  p [1,2,3].my_any? { |item| item == 4 } == false
  p [nil, false, 99].my_any? == true
  p [false, nil, false].my_any? == false
  
  p [1,2,3].my_none? { |item| item == 2 } == false
  p [1,2,3].my_none? { |item| item == 4 } == true
  p [].my_none? == true
  p [nil].my_none? == true
  p [nil, false].my_none?
  
  p [1,2,4,2].my_count == 4
  p [1,2,4,2].my_count(2) == 2
  p [1,2,4,2].my_count(3) == 0
  p [1,2,4,2].my_count { |x| x%2 == 0 } == 3

  p (1..4).my_map { |i| i*i } == [1, 4, 9, 16]
  p (1..4).my_collect { "cat" } == ["cat", "cat", "cat", "cat"]

  p (5..10).my_inject(:+) == 45
  p (5..10).my_inject { |sum, n| sum + n } == 45
  p (5..10).my_inject(1, :*) == 151200
  p (5..10).my_reduce(1) { |product, n| product * n } == 151200
end