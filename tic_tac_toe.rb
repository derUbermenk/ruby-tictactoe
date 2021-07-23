<<-DOC
  make the input statements inside the play game method, separate from player
  halt_condition:: Game; add another condition for quiting game, get the cue from input method

  reomove input cue in player put piece
DOC

# Game object, use this to play a game and get a winner
class Game
  attr_reader :p1, :p2, :winner
  attr_accessor :board, :number_of_turns

  def initialize
    @board = Board.new
    @p1 = Player.new
    @p2 = Player.new
    @number_of_turns = 5
    @force_end = false 
  end

  def play_game
    until stop_condition do
      # keep playing
      case self.number_of_turns 
      when 5..3
        player_half_turn_no_win_check p1
        player_half_turn_no_win_chec p2
        self.number_of_turns -= 1
      when 2..1
        player_half_turn_with_win_check p1
        player_half_turn_with_win_check p2
        self.number_of_turns -= 1
      when 0
        player_half_turn_with_win_check p1 
      end
    end
  end

  private

  # game halts if this is true
  def stop_condition
    has_winner = !self.winner.eql?('none')
    no_more_turns = self.number_of_turns.zero?

    has_winner || no_more_turns
  end

  # a function containing steps done when 
  # ... one player's turn to move is needed
  # ... no check for win is done 
  def player_half_turn_no_win_check(player)
    player.put_piece
    self.board.show
  end

  # a function containing steps done when 
  # ... one player's turn to move is needed
  # ... check for win is done 
  def player_half_turn_with_win_check(player)
    player.put_piece
    self.board.show
    check_win player
  end

  # Checks player has achieved a win
  # 
  # @param player [Player] a Player instance
  # @return [String, NilClass] the name of the player who has won, any. Else returns nil
  def check_win(player)
    player_piece = player.piece
    board_lines = [board.rows, board.columns, board.diagonals]

    # where board_line can either be the rows, columns and diagonals array
    has_win = board_lines.map{|board_line| 
              check_board_line_for_win(board_line, player_piece)}.include? true

    return unless has_win
      @winner = player.name
      self.winner
  end

  # Checks a group of lines -- rows, cols, diagonal contain a 
  # ... at least one line with the same characters. 
  # ... Note that a group of lines is represented as 
  # ... [row1,row2, row3], and each row is also an array 
  #
  # @param board_lines [Array] an array containing lines of the same orientation,
  # ... either rows, columns, diagonals
  # @param char [String, Symbol, Integer] something that can take a position in a line
  # 
  # @return [TrueClass,FalseClass] returns true only when at least one line is has only one 
  # ... character in all its positions
  def check_board_line_for_win lines, char
    lines.map{|line| line.all?(char)}.include?(true)
  end
end


# An object that can put pieces on a board
class Player
  attr_reader :name, :piece, :board

  # Initializes a player object
  #
  # @param name [String] the name of the player
  # @param piece [String] the piece that the player can place on the board
  # @param board [Board] the board for which the player plays in
  def initialize (name, piece, board)
    @name = name
    @piece = piece
    @board = board
  end

  # Allows a player instance in the board heshe is playing
  def put_piece

    puts 'choose piece position'
    piece = self.piece
    if is_int?(piece_position)
      case piece_position
      when [0..8]
        self.board.update_board(piece_position.to_i, self.piece)
      else
        puts 'piece position out of range'
        put_piece
      end
    else
      case piece_position.downcase
      when 'z'
        puts 'ending game'
      else
        puts 'piece position out of range'
        put_piece
      end
    end
  end

  private

  # Checks if an input is an integer.
  # 
  # @param input [String] the string to check if int
  # @return [TrueClass, FalseClass] returns true if int
  def is_int?(input)
    input.to_i.to_s.eql? input
  end
end


class Board
  def initialize  
    # where the key is position index and value is position value
    @positions = {
      0 => 0,
      1 => 1,
      2 => 2,
      3 => 3,
      4 => 4,
      5 => 5,
      6 => 6,
      7 => 7,
      8 => 8
    }
  end

  def update_board(index, value)
    self.positions[index] = value
  end

end
