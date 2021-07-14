# Use this object as an interface between a board and a player ...
class Game
  def initialize
    @board = Board.new()
    @player1 = Player.new(player: 'player1', on_board: board, piece: 'X')
    @player2 = Player.new(player: 'player2', on_board: board, piece: 'O')
    @winner = :none
  end

  def playGame
    turns_left = 5
    winner = :none

    while (winner == :none) && turns_left.positive?
      until turns_left == 3
        player_move_wCheck(p1)
        player_move_wCheck(p2)
        turns_left -= 1
      end
      until turns_left == 1
        player_move_noCheck(p1)
        player_move_noCheck(p2)
        turns_left -= 1
      end
      player_move_wCheck(p1)
      turns_left -= 1
    end
    winner == :none ? self.winner = 'draw' : winner # return the winner
  end

  protected

  def check_winner(player_to_check)
    # check for some condition taking the current player's piece into consideration

  end

  def player_move_wCheck(player)
    piece_position = player.put_piece
    if [0..8].include?(piece_position)
      board.update(piece_position, player.piece)
      self.check_winner
    else
      case piece_position
      when 'z'
        puts 'ending game'
        break
      else
        player_move(player) # try again
    end
  end

  def player_move_noCheck(player)
    piece_position = player.put_piece
    if [0..8].include?(piece_position)
      board.update(piece_position, player.piece)
    else
      case piece_position
      when 'z'
        puts 'ending game'
        break
      else
        player_move(player) # try again
    end
  end

  private

  def p1
    @player1
  end

  def p2
    @player2
  end

  def board
    @board
  end
end

# Player object acts as interface between ...
# ... program and method
class Player
  attr_reader :player_name, :piece

  # @param [player_name] String the name of the player
  # @param [board] Board the board where the players will play
  # @param [piece] String the character that player places on board X|O
  def initialize(player_name, piece)
    @player_name = player_name
    @piece = piece
  end

  def put_piece
    puts 'enter piece position'
    gets.chomp
  end

end

# a board is the object where a player can place their piece on the board. ..
# Changing board representation to array of hashes
class Board
  def initialize
    @rows = [{ 0 => 0, 1 => 1, 2 => 2 },
             { 3 => 3, 4 => 4, 5 => 5 },
             { 6 => 6, 7 => 7, 8 => 8 }]
  end

  def show_board
    str_rows = rows.map{|row| row.values.join(' | ')}
    graphic_board = " #{str_rows[0]} \n #{str_rows[1]} \n #{str_rows[2]} "
    puts graphic_board
  end

  # @param [piece_position] Integer the position where piece is to be placed
  # @param [piece] String the piece to be placed in the position
  def board_update(piece_position, piece)
    # change the value at key piece position  with piece
    case piece_position
    when 0..2
      row[0][piece_position] = piece
    when 3..5
      row[1][piece_position] = piece
    when 6..8
      row[2][piece_position] = piece
    end
  end

  private

  def rows
    @rows
  end
end
