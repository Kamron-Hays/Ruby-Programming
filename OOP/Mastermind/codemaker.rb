#!/usr/bin/env ruby

require_relative "game"
#require 'io/console'

class CodeMaker
  attr_accessor :code

  def initialize(human = true)
    @human = human
    @code = []
  end

  def human?
    @human
  end

  def create_secret_code
    if @human
      prompt = "\nCodemaker: enter the 4-digit secret code using the numbers 1-6: "
      @code = Game.input_to_code(prompt)
    else
      @code.clear
      4.times { @code << rand(1..6) }
    end
  end

  def submit_guess(guess)
    correct = 0
    misplaced = 0
    code = @code.dup

    guess.each_with_index do |digit, i|
      if digit == code[i]
        correct += 1 # Correct digit and position
        guess[i] = nil
        code[i] = nil
      end
    end

    guess.each_with_index do |digit, i|
      if digit && i = code.index(digit)
        misplaced += 1 # Correct digit, wrong position
        code[i] = nil
      end
    end
    [correct, misplaced]
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd
  c = CodeMaker.new
  c.create_secret_code
  p c.submit_guess([1,1,2,2])
end