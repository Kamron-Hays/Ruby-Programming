#!/usr/bin/env ruby

require_relative "game"
require 'io/console'

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
      @code = Game.input_to_code(prompt, true)
    else
      @code.clear
      4.times { @code << rand(1..6) }
    end
  end

  def submit_guess(guess)
    Game.get_feedback(@code, guess)
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd
  c = CodeMaker.new
  c.create_secret_code
  p c.submit_guess([1,1,2,2])
end
