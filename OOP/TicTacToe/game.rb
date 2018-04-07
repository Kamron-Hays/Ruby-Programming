#!/usr/bin/env ruby

require_relative "board"
require_relative "player"
require_relative "ai"

class Game
  def run
    @board = Board.new
    choose_human_or_machine('X')
    choose_human_or_machine('O')
    @board.draw

    while true  
      @board.mark_X( @player_X.get_next_move(@board) )
      @board.draw
      break if end_of_game?
      @board.mark_O( @player_O.get_next_move(@board) )
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
      puts ""
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

  def choose_human_or_machine(player)
    print "Is player #{player} human or machine? [h|m]: "
    $stdout.flush # needed to prevent cygwin from hanging
    response = gets.chomp.downcase

    if response == 'h' || response == 'hu' || response == 'hum' ||
       response == 'huma' || response == 'human'
      if ( player == 'X' )
        @player_X = Player.new(true)
      else
        @player_O = Player.new(false)
      end
    else # machine
      if ( player == 'X' )
        @player_X = AI_Player.new(player)
      else
        @player_O = AI_Player.new(player)
      end
    end
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd
  Game.new.run
end
