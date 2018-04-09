#!/usr/bin/env ruby

require_relative "game"

# When an instance of this class is not human (i.e. machine), the Swaszek
# variation on Knuth 5-guess algorithm is used:
# 
# 1) Create an array (S) of all possible combinations. With four digits and
#    six numbers there are 6**4 = 1296 different combinations.
# 2) Start with an initial guess of 1122. Other initial guesses may take
#    more than five tries.
# 3) Play the guess to get a response.
# 4) If the response = 4 for "correct digit and position", you've guessed
#    the secret code. Done.
# 5) Otherwise, remove all items from S that cannot possibly be the secret
#    code: for each element i of S, determine what the response would be
#    for the same guess in step 3 if i were the secret code. If it is not
#    the same response received from step 3, remove this element from S.
#    It cannot possibly be the secret code.
# 6) Randomly choose from the remaining candidates from S as the next guess.
#    Alternately always choose the first element in the list.
# 7) Repeat steps 4-6 until done.
#
# This variation is much simpler to implement, but occasionally requires
# six guesses to break the code.
class CodeBreaker
  def initialize(human = true)
    @human = human
    @guess = nil

    if !human
      # generate the set of all possible codes
      @set = []
      digits = [1,2,3,4,5,6]
      for i in digits
        for j in digits
          for k in digits
            for l in digits
              @set << [i,j,k,l]
            end
          end
        end
      end
    end
  end

  def get_guess
    if @human
      prompt = "Codebreaker: enter your guess using the numbers 1-6: "
      @guess = Game.input_to_code(prompt)
    else
      sleep(0.5)
      if !@guess
        @guess = [1,1,2,2] # always the first guess
      else
        @guess = @set[rand(@set.length)]
      end
      puts "Guess is: #{@guess}"
      STDOUT.flush
    end
    @guess
  end

  def set_response(response)
    if !@human
      # Iterate through the set of possible codes. If any give the same
      # response as the most recent guess, they might be the actual code.
      # All others should be deleted from the set.
      @set.delete_if { |code| response != Game.get_feedback(code, @guess) }
    end
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd

end
