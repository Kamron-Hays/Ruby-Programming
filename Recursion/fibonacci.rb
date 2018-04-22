#!/usr/bin/env ruby

# Returns the first 'n' numbers in the Fibonacci sequence, using iteration.
def fibs(n)
  seq = [1, 1]
  (n-2).times { seq << seq[-1] + seq[-2] }
  seq
end

# Returns the first 'n' numbers in the Fibonacci sequence, using recursion.
def fibs_rec(n)
  return [1,1] if n <= 2
  seq = fibs_rec(n-1)
  seq << seq[-2] + seq[-1]
end

p fibs(-1) == [1,1]
p fibs(0)  == [1,1]
p fibs(1)  == [1,1]
p fibs(6)  == [1,1,2,3,5,8]

p fibs_rec(-1) == [1,1]
p fibs_rec(0)  == [1,1]
p fibs_rec(1)  == [1,1]
p fibs_rec(6)  == [1,1,2,3,5,8]
