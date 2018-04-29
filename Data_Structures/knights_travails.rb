#!/usr/bin/env ruby

# A knight in chess can move to any square on the standard 8x8 chess board from
# any other square on the board, given enough turns. All the possible places the
# knight can end up (and the path to get there) can be represented by a graph.
# For a basic description of graphs, see
# https://www.khanacademy.org/computing/computer-science/algorithms/graph-representation/a/describing-graphs.

class Knight
  attr_accessor :position, :neighbors

  # Rules that govern relative movement for a Knight.
  RULES = [[1,2], [-1,2], [1,-2], [-1,-2],
           [2,1], [-2,1], [2,-1], [-2,-1]]

  # Creates a Knight at the specified position (x,y pair).
  def initialize(position)
    @position = position
    @neighbors = []
  end

  # Returns an array of all possible moves from this Knight's current position.
  # No check is performed to determine if the move is legal.
  def get_moves
    moves = []
    x,y = @position
    RULES.each do |rule|
      moves << [x + rule[0], y + rule[1]]
    end
    moves
  end

  def to_s
    "Knight@[#{@position[0]},#{@position[1]}]"
  end
  alias :inspect :to_s
end

# The Board is a Graph that contains a Knight at every position, along with
# the path of how it got there.
class Board
  attr_accessor :knights

  def initialize
    @knights = {}

    # Place a knight at every position on the 8x8 board
    # These represent the vertices of the graph.
    (0..7).each do |x|
      (0..7).each do |y|
        pos = [x,y]
        @knights[pos] = Knight.new(pos)
      end
    end

    # Now determine the edges between all associated vertices.
    # This will be a list of neighbors for each knight (i.e. all legal
    # moves for the knight).
    @knights.each do |pos, knight|
      knight.get_moves.each do |move|
        if legal?(move)
          knight.neighbors << @knights[move]
        end
      end
    end
  end

  def legal?(pos)
    x,y = pos
    x >= 0 && x <= 7 && y >= 0 && y <= 7
  end
end

# https://stackoverflow.com/questions/8379785/how-does-a-breadth-first-search-work-when-looking-for-shortest-path
if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd

  board = Board.new
end