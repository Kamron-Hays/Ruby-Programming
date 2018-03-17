#!/usr/bin/env ruby

=begin
The bubble sort general algorithm is to repeatedly pass over all elements of a
list. At each step, if two adjacent list elements are not in order, they are
swapped. So, smaller elements "bubble" to the front (or bigger elements "bubble"
to the back). Equal elements should never be swapped. If an entire traversal
of the list contains no swaps, the list is sorted.

An optimization can be made if it is realized that at the end of the i-th pass,
the last i numbers are already sorted. Consider the sequence {3, 9, 1, 7}. After
the first pass, the 9 will end up in the final position; it need not be
considered on subsequent passes.

Another optimization: let a[j] and a[j+1] be the last two numbers swapped in the
i-th pass. All numbers following this swap are already sorted. The next pass
need only consider the numbers prior to the swap. The first optimization only
lets us ignore the last number of each pass; this optimization can ignore
potentially many numbers in each pass.
=end

def bubble_sort(list)
  bubble_sort_by(list) { |a, b| a <=> b }
end

def bubble_sort_by(list)
  return list if list.length < 2 # already sorted
  return to_enum(__method__) { |a, b| a <=> b } unless block_given?

  last = list.length - 1 # index of the last swap
  while last > 0
    new_last = 0
    last.times do |i|
      if yield(list[i], list[i+1]) > 0 # not in order
        list[i], list[i+1] = list[i+1], list[i] # swap
        new_last = i
      end
    end
    last = new_last
  end
  list
end

p bubble_sort([]) == []
p bubble_sort([1]) == [1]
p bubble_sort([5,4,3,2,1]) == [1,2,3,4,5]
p bubble_sort([4,3,78,2,0,2]) == [0,2,2,3,4,78]
p bubble_sort(["hi", "hey", "hello"]) == ["hello", "hey", "hi"]
p bubble_sort_by(["hi","hello","hey"]) { |a, b| a.length <=> b.length } == ["hi", "hey", "hello"]
p bubble_sort_by([1,2,3,4,5]) { |a, b| a < b ? 1 : 0 } == [5,4,3,2,1] # reverse sort
