#!/usr/bin/env ruby

class Pair
  attr_accessor :index, :score

  def initialize(score = nil, index = nil)
    @score = score
    @index = index
  end

  def to_s
    "[" + index.to_s + "," + score.to_s + "]"
  end
end

class AI_Player
  attr_accessor :debug

  def initialize(mark = 'X')
    @mark = mark
    @debug = false
  end

  def get_next_move(board)
    square = calc_best_move(board.cells, @mark).index + 1
    puts "Player #{@mark} chooses square " + square.to_s
    sleep(0.5) # slow this down to human speed
    square
  end
  
  # Examines the specified board cells and returns a list of indexes
  # of those cells that are empty (unmarked).
  def get_empty_cells(cells)
    arr = []
    cells.each_with_index { |cell, i| arr << i if cell != 'O' && cell != 'X' }
    arr
  end

  # Returns true if the specified player has a winning combination
  # on the specified board cells.
  def winning?(cells, player)
    status = false
    if (cells[0] == player && cells[1] == player && cells[2] == player) ||
       (cells[3] == player && cells[4] == player && cells[5] == player) ||
       (cells[6] == player && cells[7] == player && cells[8] == player) ||
       (cells[0] == player && cells[3] == player && cells[6] == player) ||
       (cells[1] == player && cells[4] == player && cells[7] == player) ||
       (cells[2] == player && cells[5] == player && cells[8] == player) ||
       (cells[0] == player && cells[4] == player && cells[8] == player) ||
       (cells[2] == player && cells[4] == player && cells[6] == player)
      status = true
    end
    status
  end

  # Uses the Minimax algorithm to determine the best next move to make for the
  # specified player and the current board cell configuration. It examines every
  # possible move that could be made, all the way up to a terminal state of the
  # game - one that results in a win, a loss, or a tie. Once in a terminal state,
  # an arbitrary score is assigned - a positive score (+10) for a win, a
  # negative score (-10) for a loss, or a neutral score (0) for a tie. With this
  # approach, a sequence that takes five turns to win or lose will have the same
  # score as a sequence that takes one turn. Since it is desired to be ruthless
  # and win as soon as possible (or fight to the bitter end), a winning sequence
  # (from the AI player's perspective) will have the number of turns subtracted
  # from its score. Similarly, a losing sequence will have the number of turns
  # added to its score. This method is recursive, with each call representing
  # each player's turn. Once all moves are scored for a turn, the highest score
  # is chosen if it's this AI player's turn. The lowest score is chosen if it's
  # the opponent's turn (i.e the best move for the opponent).
  #
  # Returns the best move as a Pair - the cell index and associated score.
  def calc_best_move(cells, player, turns=-1)
    turns += 1
    empty_cells = get_empty_cells(cells)

    # In the event all cells are empty, just pick a random cell.
    return Pair.new(0, rand(9)) if empty_cells.length == 9

    # Checks for the terminal states win, lose, and tie and returns a score
    # accordingly. We don't have the associated index, but it is known at
    # the previous "level" - i.e. we will only get here from recursion.
    final_move = nil
    if winning?(cells, @mark == 'X' ? 'O' : 'X')
      final_move = Pair.new(turns - 10)
      print " " * (turns*4) + "Player #{@mark == 'X' ? 'O' : 'X'} wins." if @debug
    elsif winning?(cells, @mark)
      final_move = Pair.new(10 - turns)
      print " " * (turns*4) + "Player #{@mark} wins." if @debug
    elsif empty_cells.length == 0
      final_move = Pair.new(0)
      print " " * (turns*4) + "It's a tie." if @debug
    end

    if final_move
      puts " Score #{final_move.score.to_s} for this series of moves" if @debug
      return final_move
    end

    if @debug
      puts " " * (turns*4) + "Player #{player}'s turn"
      puts " " * (turns*4) + "Current board state: " + cells.to_s
      puts " " * (turns*4) + "Possible moves are: " + empty_cells.to_s
    end

    moves = []
    # loop through available cells
    empty_cells.each do |i|
      puts " " * (turns*4) + "What if player #{player} chooses cell " + i.to_s if @debug
      # create an object to store this move and its associated score
      move = Pair.new
      move.index = i

      # mark the empty cell for the current player
      cells[i] = player

      # Alternate each player's moves to a terminal state to get a sequence score.
      if player == @mark
        result = calc_best_move(cells, @mark == 'X' ? 'O' : 'X', turns)        
      else
        result = calc_best_move(cells, @mark, turns)
      end

      # Save the score for this sequence.
      move.score = result.score

      # return the cell back to empty (undo the move)
      cells[i] = " "
  
      # save the move (along with it's associated score)
      moves << move
    end

    # Apply a Minimax algorithm to choose the "best" move for the
    # associated player (depending on whose turn it is).
    best_move = nil
    if player == @mark # it's our turn
      best_score = -10
      puts " " * (turns*4) + "Player #{player} will choose the highest score between:" if @debug
      moves.each_with_index do |move, i|
        puts " " * (turns*4) + move.to_s if @debug
        if move.score > best_score
          best_score = move.score
          best_move = i
        end
      end
    else # it's the opponent's turn - assume they will make the best move to defeat us
      best_score = 10
      puts " " * (turns*4) + "Player #{player} will choose the lowest score between:" if @debug
      moves.each_with_index do |move, i|
        puts " " * (turns*4) + move.to_s if @debug
        if move.score < best_score
          best_score = move.score
          best_move = i
        end
      end
    end

    # return the best move
    puts " " * (turns*4) + "Choosing " + moves[best_move].to_s if @debug
    moves[best_move]
  end
end

if __FILE__ == $0
  # this will only run if the script is the main, not load'd or require'd

  cells1 = ['X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
  cells2 = ['X', 'O', ' ', 'O', 'X', ' ', ' ', 'O', ' ']
  cells3 = ['O', 'X', 'X', 'O', 'X', 'X', ' ', 'O', 'O']
  # The following is a no-win scenario for X. He should fight to the bitter end.
  cells4 = [' ', 'O', ' ', ' ', ' ', 'O', 'X', 'X', 'O']

  ai = AI_Player.new
  #ai.debug = true

  # How long does this turn take? It's the worst-case scenario.
  start = Time.now
  ai.calc_best_move(cells1, 'O')
  p Time.now - start

  p ai.calc_best_move(cells2, 'X').index == 8
  p ai.calc_best_move(cells3, 'X').index == 6
  p ai.calc_best_move(cells4, 'X').index == 2
end
