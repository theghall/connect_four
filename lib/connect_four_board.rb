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
    raise ArgumentError.new("Row/Col must be between 0 and 3") \
      unless valid_pos?(row, col)

    board[row][col] = token

    true
  end

  def display
    board.each do |row|
      row.each do |e|
        print(e)
      end
      puts
    end
  end

  private

  attr_writer :board

  def valid_pos?(row, col)
    return row.between?(0, 3) && col.between?(0, 3)
  end
end

