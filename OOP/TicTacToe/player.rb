class Player
  def initialize(is_X)
    @is_X = is_X
  end
  
  # Should return a legal board position 1-9
  def get_next_move(board)
    position = nil
    while true
      print "Player " + (@is_X ? "X" : "O") + " - choose a square (1-9): "
      $stdout.flush # needed to prevent cygwin from hanging
      position = gets.chomp.to_i
      break if board.legal_move?(position)
      puts "Not a legal move!"
    end
    position
  end
end
