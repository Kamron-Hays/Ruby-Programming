#!/usr/bin/env ruby

=begin
In cryptography, a Caesar cipher, is one of the simplest and most widely known
encryption techniques. It is a type of substitution cipher in which each letter
in the plaintext is replaced by a letter some fixed number of positions down
the alphabet. For example, with a left shift of 3, D would be replaced by A,
E would become B, and so on. The method is named after Julius Caesar, who used
it in his private correspondence.
=end

Lower = ('a'..'z').to_a
Upper = ('A'..'Z').to_a

def caesar_cipher(input, shift)
  result = ""

  # iterate over each character in the string
  input.each_char do |c|
    index = Lower.index(c)
    if index != nil
      result += Lower[(index + shift) % 26]
    else
      index = Upper.index(c)
      if ( index != nil )
        result += Upper[(index + shift) % 26]
      else
        result += c
      end
    end
  end
  
  result
end

puts caesar_cipher("What a string!", 5)
puts caesar_cipher("What a string!", 5) == "Bmfy f xywnsl!"
