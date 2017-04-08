# connect_four.rb
#
# 20170408	GH
#
class ConnectFourBoard
  attr_reader :board

  def initialize
    @board = Array.new(4) {Array.new(4, '.')}
  end

  def place_token(token, row, col)
    return false unless valid_pos?(row, col)

    board[row][col] = token

    true
  end

  def display
  end

  private

  attr_writer :board

  def valid_pos?(row, col)
    return row.between?(0, 3) && col.between?(0, 3)
  end
end

