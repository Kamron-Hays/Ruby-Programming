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
  end

  def my_all?
  end

  def my_any?
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
