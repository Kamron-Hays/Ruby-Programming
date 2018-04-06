#!/usr/bin/env ruby

require_relative "board"
require_relative "player"

class Game
  # Add option to choose player type (human or computer)
  # Option to quit game?
  def run
    @board = Board.new
    @player1 = Player.new(true)
    @player2 = Player.new(false)
    @board.draw

    while true  
      @board.mark_X( @player1.get_next_move(@board) )
      @board.draw
      break if end_of_game?
      @board.mark_O( @player2.get_next_move(@board) )
      @board.draw
      break if end_of_game?
    end
  end

  private

  def end_of_game?
    is_end = false
    winner = @board.check_winner

    if winner
      puts winner + " wins!"
      is_end = true
    else
      if !@board.moves_left?
        puts "It's a tie!"
        is_end = true
      end
    end

    if is_end
      print "Play again? [y|n]: "
      $stdout.flush # needed to prevent cygwin from hanging
      response = gets.chomp.downcase
      if response == 'y' || response == 'ye' || response == 'yes'
        is_end = false
        @board = Board.new
        @board.draw
      end
    end
    is_end
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd
  Game.new.run
end
