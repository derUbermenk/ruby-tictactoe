# code for playing tctactoe

# a class for playing the game
class Game
  attr_reader :p1, :p2
  attr_accessor :board

  def initialize
    @board = Board.new 
    @p1 = Player.new(piece: 'X', board: board)
    @p2 = Player.new(piece: 'O', board: board)
  end

  def playGame
  end



end

# a class for where pieces are to be played
class Board
  attr_accessor :positions

  def initialize
    @positions = [
      Position.new(0, 0), Position.new(1, 1),
      Position.new(2, 2), Position.new(3, 3),
      Position.new(4, 4), Position.new(5, 5),
      Position.new(6, 6), Position.new(7, 7),
      Position.new(8, 8)
    ]
  end

  def show_board
    puts " #{positions[0..2].join(' | ')} \n #{positions[3..5].join(' | ')}  \n
     #{positions[6..8].join(' | ')} "
  end

  def update_board(position, piece)
    # change the value of position with piece; piece is a string
    positions[position].value = piece
  end
end

# a class that places pieces
class Player
  attr_reader :piece

  # @argument [piece] String
  def initialize(piece, board)
    @piece = piece
    @board = board
  end

  def put_piece
    position = gets.chomp
    board.update(position, piece)
  end
end

class Position
  attr_reader :index
  attr_accessor :value

  def initialize(index, value)
    @index = index
    @value = value
  end
end