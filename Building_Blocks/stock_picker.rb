#!/usr/bin/env ruby

=begin
Implement a method #stock_picker that takes in an array of stock prices, one
for each hypothetical day. It should return a pair of days representing the
best day to buy and the best day to sell. Days start at 0.

  > stock_picker([17,3,6,9,15,8,6,1,10])
  => [1,4]  # for a profit of $15 - $3 == $12

Quick Tips:

You need to buy before you can sell
Pay attention to edge cases like when the lowest day is the last day or the
highest day is the first day.
=end

def stock_picker(prices)
  if prices.length < 2
    return nil
  end

  days = nil
  max_profit = 0

  prices.each_index do |i|
    prices.each_index do |j|
      next unless j > i
      profit = prices[j] - prices[i]

      if profit > max_profit
        max_profit = profit
        days = [i, j]
      end
    end
  end

  days
end

puts stock_picker([17,3,6,9,15,8,6,1,10]) == [1,4]
