# Board, stores game inputs
class Board
  attr_accessor :positions

  # Initializes a vanilla board instances, initial values are numbers
  # ... where key is position index and value is position value
  def initialize
    @positions = {
      0 => 0, 1 => 1,
      2 => 2, 3 => 3,
      4 => 4, 5 => 5,
      6 => 6, 7 => 7,
      8 => 8
    }
  end

  # change the value of hash element with key index by the given value
  #
  # @param index [Integer] the key of the position to be changed
  # @param value [String, Integer, Symbol] the value to be substituted
  def update_board(index, value)
    self.positions[index] = value
  end

  def show_board
    row_vals = [self.positions[0..2], self.positions[3..5], self.positions[6..8]]
    rows = row_vals.map{|row| row.join(" | ")}
    puts " #{rows[0]} \n #{row[1]} \n #{row[2]} "
  end
  
  def board_full
    self.positions.any? Integer
  end

  # checks if any line in the board is a line made up of x
  #
  # @param with_x [String] possible value that can make up a straight line
  # @return [TrueClass]
  def has_straight_line?(with_x)
    has_straigt_row? = [1,4,7].map{|midpoint| [midpoint-=1, midpoint, midpoint+=1].all? with_x }.include? True
    has_straight_col? = [3,4,5].map{|midpoint| [midpoint+=1]}
  end

  private

  # Helper for has_straigh_lines
  # Checks if any of the lines [3 points] represented by the midpoints
  # ... has the given element x as the value of all positions. This 
  # ... function is limited to 3 point lines i.e X X X or 1 2 3
  #
  # @param midpoints [Array] array indexes representing the midpoint of a row
  # @param spacing [Integer] the spacing between two points
  # @param x [String] the value that one line should contain to be defined as straight
  def line_checker(midpoints, spacing, x)
    midpoints.map{|midpoint| [midpoint-=1, midpoint, midpoint+=1].all? x}.include? True
  end
end
