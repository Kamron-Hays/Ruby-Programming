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
    return true unless block_given?
    self.my_each do |item|
      return false unless yield(item)
    end
    true
  end

  def my_any?
    return true unless block_given?
    self.my_each do |item|
      return true if yield(item)
    end
    false
  end

  def my_none?
  end

  def my_count
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

p [1,2,3].my_any? { |item| item == 2 } == true
p [1,2,3].my_any? { |item| item == 4 } == false
