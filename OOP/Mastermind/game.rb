#!/usr/bin/env ruby

require_relative "codemaker"
require_relative "codebreaker"

class Game
  def initialize
    @codemaker = nil
    @codebreaker = nil
    @max_turns = 12
  end

  def run
    display_rules
    turn = 0
    setup

    while true
      turn += 1
      puts "\nTurn #{turn}"
      response = @codemaker.submit_guess( @codebreaker.get_guess )
      @codebreaker.set_response(response)

      if response[0] == 4
        puts "\nYou broke the code!"
        game_over = true
      else
        puts "Correct digit and position: #{response[0]}"
        puts "Correct digit, wrong position: #{response[1]}"
      end

      if turn >= @max_turns
        puts "\nYou're out of turns!\nThe secret code was #{@codemaker.code}"
        game_over = true
      end

      if game_over
        break if !play_again?
        game_over = false
        turn = 0
        setup
      end
    end
  end

  def self.get_feedback(code, guess)
    correct = 0
    misplaced = 0
    c = code.dup
    g = guess.dup

    g.each_with_index do |digit, i|
      if digit == c[i]
        correct += 1 # Correct digit and position
        g[i] = nil
        c[i] = nil
      end
    end

    g.each_with_index do |digit, i|
      if digit && i = c.index(digit)
        misplaced += 1 # Correct digit, wrong position
        c[i] = nil
      end
    end
    [correct, misplaced]
  end
  
  private

  def setup
    # prompt codebreaker, codemaker, or rules (stay in setup if rules is requested)
    print "\nShall the Codemaker be human or machine? [h|m]: "
    @codemaker = CodeMaker.new(response_human?)

    print "Shall the Codebreaker be human or machine? [h|m]: "
    @codebreaker = CodeBreaker.new(response_human?)

    @codemaker.create_secret_code
  end

  def self.input_to_code(prompt, secret = false)
    while true
      print prompt
      $stdout.flush

      if secret
        text = $stdin.noecho(&:gets)
      else
        text = gets
      end

      code = []
      text.chomp.split("").each { |ch| code << ch.to_i }

      if code.length == 4 && code.all? { |digit| digit.between?(1, 6) }
        break
      else
        puts "Invalid code."
      end
    end
    code
  end

  def response_human?
    status = false
    $stdout.flush # needed to prevent cygwin from hanging
    response = gets.chomp.downcase

    if response == 'h' || response == 'hu' || response == 'hum' ||
       response == 'huma' || response == 'human'
       status = true
    end
    status
  end

  def play_again?
    status = false
    print "\nWould you like to play again? [y|n]: "
    $stdout.flush # needed to prevent cygwin from hanging
    response = gets.chomp.downcase

    if response == 'y' || response == 'ye' || response == 'yes'
       status = true
    end
    status
  end

  def display_rules
    puts "The object of Mastermind is to guess a secret code. Each guess results\n" +
         "in feedback to assist in narrowing down the possibilities. The winner is\n" +
         "the player who solves his opponent's secret code with fewer guesses.\n" +
         "\n" +
         "One player, known as the Codemaker, chooses the secret code (a series of\n" +
         "four digits, each numbered from 1 to 6). The other player, known as the\n" +
         "Codebreaker, receives up to twelve chances to guess the code. After each\n" +
         "guess, two counts are given as feedback: 1) the number of digits that\n" +
         "are correct and also in the correct position, and 2) the number of digits\n" +
         "that are correct but in the wrong position."
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd
  Game.new.run
end
