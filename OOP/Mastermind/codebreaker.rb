#!/usr/bin/env ruby

require_relative "game"

class CodeBreaker
  def initialize(human = true)
    @human = human
  end

  def human?
    @human
  end

  def get_guess
    guess = nil
    if @human
      prompt = "Codebreaker: enter your guess using the numbers 1-6: "
      guess = Game.input_to_code(prompt)
    else
      guess = []
      4.times { guess << rand(1..6) }
    end
    guess
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd

end
