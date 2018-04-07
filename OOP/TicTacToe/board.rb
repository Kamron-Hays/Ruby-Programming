Winning_Combos = [ [0,1,2], [3,4,5], [6,7,8],
                   [0,3,6], [1,4,7], [2,5,8],
                   [0,4,8], [2,4,6] ]

class Board
  attr_accessor :cells

  def initialize
    @size = 9
    @cells = Array.new(@size, " ")
  end

  def legal_move?(position)
    return position > 0 && position <= @size && @cells[position-1] == " "
  end

  def mark_X(position)
    return mark(position, 'X')
  end
  
  def mark_O(position)
    return mark(position, 'O')
  end

  def get(position)
    value = nil
    if position <= @size
      value = @cells[position-1]
    end
    value
  end

  def draw
    puts
    puts "Board:                Legend:"
    puts " #{@cells[0]} | #{@cells[1]} | #{@cells[2]}             1 | 2 | 3"
    puts "---+---+---           ---+---+---"
    puts " #{@cells[3]} | #{@cells[4]} | #{@cells[5]}             4 | 5 | 6"
    puts "---+---+---           ---+---+---"
    puts " #{@cells[6]} | #{@cells[7]} | #{@cells[8]}             7 | 8 | 9"
    puts
    $stdout.flush
  end
  
  # returns true if there are any 'open' cells on the board; otherwise returns false
  def moves_left?
    status = false
    for item in @cells do
      if item == " "
        status = true
        break
      end
    end
    status
  end

  # returns nil if no winner, 'X' if X is the winner, or 'O' if O is the winner
  def check_winner
    winner = nil
    for c in Winning_Combos do
      if @cells[c[0]] != " " &&
         @cells[c[0]] == @cells[c[1]] &&
         @cells[c[0]] == @cells[c[2]]
        winner = @cells[c[0]]
        break
      end
    end
    winner
  end

  private

  def mark(position, letter)
    status = false
    if legal_move?(position)
      @cells[position-1] = letter
      status = true
    end
    status
  end
end
