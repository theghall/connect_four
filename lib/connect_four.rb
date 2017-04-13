# connect_four.rb
#
# 20170408	GH
#
module ConnectFour

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

  class ConnectFourPlayer
   attr_reader :name, :token

   def initialize(name, token)
     @name = name
    
     @token = token
   end

   def take_turn(board, judge)
     loop do
       print("Enter position: ")

       pos = gets.chomp

       ary = pos.split(',').map{ |e| e.to_i }

       begin
         token_placed = board.place_token(token, ary[0], ary[1]) if judge.valid_move?(ary[0], ary[1])
       rescue ArgumenError => e
         puts('Choose another position')
       end

       break if token_placed
     end 
   end

   private
  
   attr_writer :name, :token
 end
end
