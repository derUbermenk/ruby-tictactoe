class Game
  @attr_accessor :winner
  def initialize(p1, p2, board)
    @board = Board.new()
    @p1 = Player.new(piece: 'X', on_board: board)
    @p2 = Player.new(piece: 'O', on_board: board)
    @winner = :none
  end

  def play_game
    <<-DOC
    DOC
    while self.winner == :none or board.full() # board is full
      p1_turn = 1
      while p1_turn <= 2
        p1.move() # move prompts user for input of where to put his charater (X|O) and increments the current turn of player, show board thereafter
        p1_turn += 1
        p2.move() 
      p1.move() # now at turn 3
      board.show()
      self.check_winner 
      p2.move()
      board.show()
      self.check_winner
      end
    end
    self.winner
  end

  protected
  def check_winner(
      winner = self.winner, 
      p1 = p1, 
      p2 = p2, 
      board
    )
    <<-DOC
      sets the winner value
    DOC
    return winner
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

end

class Board
  <<-DOC
  DOC
end

class Player
  <<-DOC
  DOC
end