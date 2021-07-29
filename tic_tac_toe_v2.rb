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
    self.board.show

    until stop_conditions_met
      print_player_prompt(self.p1)
      game_flow(self.p1)
      break if stop_conditions_met

      print_player_prompt(self.p2)
      game_flow(self.p2)
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
  def game_flow(player)
    player_input = player.move
    case player_input
    when 'z'
      self.quit = true
    when 0..8
      if self.board.position_filled(player_input)
        puts "\n position filled \n choose another position "
        game_flow(player)
      else
        self.board.update(player_input, player.piece)
        self.winner = player.winner?
      end
    else
      puts 'invalid input'
      game_flow(player_input, player.piece)
    end
  end

  # Checks if conditions for halting the game has been met
  #
  # @return [TrueClass, FalseClass]
  def stop_conditions_met
    if has_winner
      puts "\n #{self.winner} is winner "
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
    self.board.full
  end

  # Prints a prompt for the player
  #
  # @param player[Player]
  def print_player_prompt(player)
    puts "\n #{player.name} move \n enter z to quit \n enter piece position to put piece \n "
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
  def update(index, value)
    #update only when value at index is integer
    self.positions[index] = value
    self.show
  end

  def show
    vals = self.positions.values
    row_vals = [vals[0..2], vals[3..5], vals[6..8]]
    rows = row_vals.map{ |row| row.join(' | ')}
    puts " \n #{rows[0]} \n #{rows[1]} \n #{rows[2]} \n "
  end

  # board is full unless there is a remaining position with an integer
  def full
    !self.positions.values.any? Integer
  end

  # checks if any line in the board is a line made up of x, this is a win with x
  #
  # @param with_x [String] possible value that can make up a straight line
  # @return [TrueClass]
  def win?(with_x)
    row_mp, column_mp = [1, 4, 7], [3, 4, 5]
    diagonal_mp = [4]

    # still needs fixing
    # make a clearer representation

    # checks are either true or falls depending on wether the lines of mps are not straight
    # win? returns true when at least one check returns true

    check1 = has_straight_line(row_mp, 1, with_x) || has_straight_line(column_mp, 3, with_x)    
    check2 = has_straight_line(diagonal_mp, 2, with_x) || has_straight_line(diagonal_mp, 4, with_x)

    check1 || check2
  end

  # Checks if the value at the given index is filled; value is ... 
  # ... not an integer
  # 
  # @param position_index [Integer]  
  # @return [TrueClass, FalseClass]
  def position_filled(position_index)
    !self.positions[position_index].is_a? Integer
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
    midpoints.map{|midpoint| [pos[midpoint - spacing], pos[midpoint], pos[midpoint + spacing]].all? x }.include? true
  end
end

# main
game = Game.new
puts " \n New game started \n "
game.play