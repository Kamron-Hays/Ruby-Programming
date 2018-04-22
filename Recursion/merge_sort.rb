#!/usr/bin/env ruby

# Sorts the specified array using recursion.
def merge_sort(ary)
  len = ary.length
  return ary if len <= 1 # base case
  # Divide and conquer - split the array into two halves and sort them.
  ary1 = merge_sort(ary[0...len/2])
  ary2 = merge_sort(ary[len/2...len])
  # Then merge the two sorted halves.
  merge(ary1, ary2)
end

# Combines the two specified arrays into a single array.
# It is assumed that the two arrays are already sorted in ascending order.
# The returned array will also be sorted in ascending order.
def merge(ary1, ary2)
  ary = []
  until ary1.empty? || ary2.empty?
    if ary1.first <= ary2.first
      ary << ary1.first
      ary1.shift
    else
      ary << ary2.first
      ary2.shift
    end
  end
  # There are one or more items left in the non-empty array
  ary += (ary1.empty? ? ary2 : ary1)
end

p merge([2], [1]) == [1,2]
p merge([3,4], [1,2]) == [1,2,3,4]
p merge([2,3,4], [1,2,3]) == [1,2,2,3,3,4]
p merge_sort([]) == []
p merge_sort([0]) == [0]
p merge_sort([9,0,8,1,7,2,6,3,5,4,4,5,3,6,2,7,1,8,0,9]) == [0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9]