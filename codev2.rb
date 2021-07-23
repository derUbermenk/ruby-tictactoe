# code for playing tctactoe

# a class for playing the game
class Game
  attr_reader :p1, :p2
  attr_accessor :board

  public

    def initialize
      @board = Board.new 
      @p1 = Player.new(name: 'player1', piece: 'X', board: board)
      @p2 = Player.new(name: 'player2', piece: 'O', board: board)
    end

    def play
      # stop when no turns left or when there is a winner
      # after every player move check for winner and display the board
      turns_left = 5 
      until turns_left == 0 || self.winner != nil 
        until turns_left == 3
          move(p1)
          move(p2)
          turns_left -= 1
        end
        until turns_left == 1
          move(p1)
          check_win(p1)
          move(p2)
          check_win(p1)
          turns_left -= 1
        end
        move(p1)
        check_win(p1)
        turns_left -= 1
      end
    end

  private

    def p1
      @p1
    end

    def p2
      @p2
    end

    def board 
      @board
    end
    
    def move(player)
      player.put_piece
      board.show
    end

    def check_win(player)
      player_piece = player.piece
      lines = [board.row, board.column, board.diagonal]

      bool_arr = lines.map{|line| 
        line.map{|row_col_diag| row_col_diag.all?(piece)}.include?(true)
      }

      if bool_arr.include?(true)
        self.winner = player.player_name
        break
      else
        nil 
      end
    end

end
# a class for where pieces are to be played
class Board

  def initialize
    @positions = [
      Position.new(0, 0), Position.new(1, 1), Position.new(2, 2), 
      Position.new(3, 3), Position.new(4, 4), Position.new(5, 5),
      Position.new(6, 6), Position.new(7, 7), Position.new(8, 8)
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

  def rows
    [positions[0..2], positions[3..5], positions[6..8]]
  end

  def cols
    [
      [positions[0], positions[3], positions[6]],
      [positions[1], positions[4], positions[7]],
      [positions[2], positions[5], positions[8]]
    ]
  
  def diagonal
    [
      [positions[0], positions[4], positions[8]]
      [positions[2], positions[4], positions[6]]
    ]
  end

  private

  def positions
    @positions
  end
end

# a class that places pieces
class Player
  attr_reader :piece, :player_name

  # @argument [piece] String
  def initialize(player_name, piece, board)
    @player_name = player_name
    @piece = piece
    @board = board
  end

  def put_piece
    position = gets.chomp
    board.update(position, piece)
  end

  private

  def board
    @board
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