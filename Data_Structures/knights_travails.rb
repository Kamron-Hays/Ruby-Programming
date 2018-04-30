#!/usr/bin/env ruby

# A knight in chess can move to any square on the standard 8x8 chess board from
# any other square on the board, given enough turns. All the possible places the
# knight can end up (and the path to get there) can be represented by a graph.
# For a basic description of graphs, see
# https://www.khanacademy.org/computing/computer-science/algorithms/graph-representation/a/describing-graphs.

class Knight
  attr_accessor :position, :neighbors, :previous

  # Rules that govern relative movement for a Knight.
  RULES = [[1,2], [-1,2], [1,-2], [-1,-2],
           [2,1], [-2,1], [2,-1], [-2,-1]]

  # Creates a Knight at the specified position (x,y pair).
  def initialize(position)
    @position = position
    @neighbors = []
    @previous = nil # where this knight came from - used for finding shortest path between two positions
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
    "N#{@position[0]},#{@position[1]}"
  end
  alias :inspect :to_s
end

# The Board is a Graph that contains a Knight at every position (vertices),
# along with all possible positions to which it can move (edges).
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

  # Returns true if a move to the specified position is legal. Since the
  # movements of a single piece are being modeled, a move to any position
  # is legal, as long as it's on the board.
  def legal?(pos)
    x,y = pos
    x >= 0 && x <= 7 && y >= 0 && y <= 7
  end

  # Returns a list of all the positions for the shortest route between the
  # specified start and finish positions (an x,y coordinate). A breadth-first
  # traversal is performed on the board (a graph). Since the edges in this
  # graph are unweighted (the "distance" is the same between all vertices),
  # a BFS traversal will automatically find the closest path, because vertices
  # are visited in order of their distance from the starting point. All that
  # needs to be done is save the previous node from the currently visited
  # node. Once the specified finish positon is found, the path can be built
  # by traversing from finish to start, using the "previous node" links.
  def knight_moves(start, finish)
    # Clear all the "previous" links
    @knights.each do |pos, knight|
      knight.previous = nil
    end

    # Perform the BFS traversal, saving the "previous node" links.
    queue = [ @knights[start] ]
    until queue.empty?
      knight = queue.shift
      break if knight.position == finish

      knight.neighbors.each do |neighbor|
        if neighbor.previous == nil
          # This node hasn't been visited yet.
          neighbor.previous = knight
          queue << neighbor
        end
      end
    end

    # Now follow the "previous node" links to reconstruct the path.
    path = []
    vertex = @knights[finish]
    loop do
      path.unshift(vertex.position)
      break if vertex.position == start
      vertex = vertex.previous
    end
    path
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd

  board = Board.new
  p board.knight_moves([0,0], [1,2]) == [[0,0], [1,2]]
  p board.knight_moves([0,0], [3,3]) == [[0,0], [1,2], [3,3]]
  p board.knight_moves([3,3], [0,0]) == [[3,3], [2,1], [0,0]]
end