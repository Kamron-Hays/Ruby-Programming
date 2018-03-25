#!/usr/bin/env ruby

module Enumerable
  def my_each
    return to_enum(__method__) unless block_given?
    for item in self do
      yield(item)
    end
  end
  
  def my_each_with_index
    return to_enum(__method__) unless block_given?
    self.size.times { |i| yield(self[i], i) }
  end

  def my_select
    return to_enum(__method__) unless block_given?
    arr = []
    self.my_each { |item| arr << item if yield(item) }
    arr
  end

  def my_all?
    if block_given?
      self.my_each { |item| return false if !yield(item) }
    else
      self.my_each { |item| return false if !item }
    end
    true
  end

  def my_none?
    if block_given?
      self.my_each do |item|
        return false if yield(item)
      end
    else
      self.my_each do |item|
        return false if item
      end
    end
    true
  end

  def my_any?(&block)
    !self.my_none?(&block)
  end
  
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

  def my_map
  end

  def my_inject
  end
end

arr = []
[1,2,3].my_each { |item| arr << item + 3 }
p arr == [4,5,6]

arr = []
{banana: "fruit", hamburger: "meat", carrot: "vegetable"}.my_each { |key,value| arr << key.to_s + " is a " + value }
p arr == ["banana is a fruit", "hamburger is a meat", "carrot is a vegetable"]

arr = []
[1,2,3].my_each_with_index { |item, i| arr << item * i }
p arr == [0,2,6]

p [1,2,3,4,5,6].my_select { |item| item%2 == 0 } == [2,4,6]

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
