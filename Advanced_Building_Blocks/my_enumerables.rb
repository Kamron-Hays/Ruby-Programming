#!/usr/bin/env ruby

module Enumerable
  def my_each
    return to_enum(__method__) { size } unless block_given?
    for item in self do
      yield item
    end
  end
end

arr = []
[1,2,3].my_each { |item| arr << item + 3 }
p arr == [4,5,6]

arr = []
{banana: "fruit", hamburger: "meat", carrot: "vegetable"}.my_each { |key,value| arr << key.to_s + " is a " + value }
p arr == ["banana is a fruit", "hamburger is a meat", "carrot is a vegetable"]
