require 'pry-byebug'

# Game object, initialize in order to play a game
class Game
  attr_reader :p1, :p2 
  attr_accessor :board, :quit, :winner

  def initialize
    @board = Board.new
    @p1 = Player.new('player1', 'X', self.board)
    @p2 = Player.new('player2', 'O', self.board)
    @winner = nil
    @quit = false
  end

  def play
    self.board.show_board
    until stop_conditions_met? do
      [self.p1, self.p2].each { |player|
        puts "\n #{player.name} move \n enter z to quit \n enter piece position to put piece \n"
        game_flow(player.move, player.piece)
        self.winner = player.winner?
      }
    end
  end

  private

  # A flow structure deciding the flow of the game depending
  # on the player input
  #
  # @param player_piece [String, Symbol] the piece the player puts on board
  # @param player_input [String, Int] can either be z (to quit) or any ... 
  # ... from 0 to 8 to place the piece. This is generally intended to be the ... 
  # ... the position for which the piece is to be placed
  def game_flow(player_input, player_piece)
    case player_input
    when 'z'
      self.quit = true
    when 0..8
      self.board.update_board(player_input, player_piece)
    else
      puts 'invalid input'
      game_flow(player_piece, player_input)
    end
  end

  # Checks if conditions for halting the game has been met
  #
  # @return [TrueClass, FalseClass]
  def stop_conditions_met?
    if has_winner
      puts self.winner
    elsif board_full 
      puts 'board is full'
    elsif self.quit
      puts 'game halted'
    end

    has_winner || board_full || quit
  end

  def has_winner
    !self.winner.nil?
  end

  def board_full 
    self.board.board_full
  end
end

# Player object stores player info
class Player
  attr_reader :name, :piece, :board

  def initialize(name, piece, board)
    @name = name
    @piece = piece
    @board = board
  end

  # Prompts a player for input
  #
  # @return [String, Integer] will return integer only if input is a numeral
  def move
    player_input = gets.chomp.downcase
    if numeral?(player_input)
      player_input.to_i
    else
      player_input
    end
  end

  # Checks the board if there is at least one line for which
  # ... player's pieces is the only piece
  #
  # @return [NilClass, String] will return nil if no such line exists,
  # ... or the name of the player if so
  def winner?
    player_wins = self.board.win?(self.piece)

    return self.name if player_wins
  end

  private

  # Checks if the argument is a numeral, ...
  # ... a helper function for move
  #
  # @param argument [String]
  # @return [TrueClass, FalseClass]
  def numeral?(argument)
    argument.to_i.to_s == argument
  end
end

# Board, stores game inputs
class Board
  attr_accessor :positions
  # Initializes a vanilla board instances, initial values are numbers
  # ... where key is position index and value is position value
  def initialize
    @positions = {
      0 => 0, 1 => 1, 2 => 2, 
      3 => 3, 4 => 4, 5 => 5,
      6 => 6, 7 => 7, 8 => 8
    }
  end

  # change the value of hash element with key index by the given value
  #
  # @param index [Integer] the key of the position to be changed
  # @param value [String, Integer, Symbol] the value to be substituted
  def update_board(index, value)
    self.positions[index] = value
    self.show_board
  end

  def show_board
    vals = self.positions.values
    row_vals = [vals[0..2], vals[3..5], vals[6..8]]
    rows = row_vals.map{ |row| row.join(' | ')}
    puts " #{rows[0]} \n #{rows[1]} \n #{rows[2]} "
  end

  # board is full unless there is a remaining position with an integer
  def board_full
    self.positions.any? Integer
  end

  # checks if any line in the board is a line made up of x, this is a win with x
  #
  # @param with_x [String] possible value that can make up a straight line
  # @return [TrueClass]
  def win?(with_x)
    row_mp, column_mp = [1, 4, 7], [3, 4, 5]
    diagonal1_mp, diagonal2_mp = [2, 4, 6], [0, 4, 8]

    # still needs fixing
    # make a clearer representation

    # checks are either true or falls depending on wether the lines of mps are not straight
    # win? returns true when at least one check returns true

    check1 = has_straight_line(row_mp, 3, with_x) || has_straight_line(column_mp, 1, with_x)    
    check2 = has_straight_line(diagonal1_mp, 2, with_x) || has_straight_line(diagonal2_mp, 4, with_x)

    check1 || check2
  end

  private

  # Helper for win? 
  # Checks if any of the lines [3 points] represented by the midpoints
  # ... has the given element x as the value of all positions. This 
  # ... function is limited to 3 point lines i.e X X X or 1 2 3
  #
  # @param midpoints [Array] array indexes representing the midpoint of a row
  # @param spacing [Integer] the spacing between two points
  # @param x [String] the value that one line should contain to be defined as straight
  def has_straight_line(midpoints, spacing, x)
    pos = self.positions
    midpoints.map{|midpoint| [pos[midpoint-=spacing], pos[midpoint], pos[midpoint+=spacing]].all? x}.include? true 
  end
end

# main
game = Game.new
game.play