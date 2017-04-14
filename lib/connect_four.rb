# connect_four.rb
#
# 20170408	GH
#
require 'byebug'
module ConnectFour

  class ConnectFourBoard
    attr_reader :board

   def initialize
     @board = Array.new(4) {Array.new(4, '.')}
   end

   def place_token(token, col)
     raise ArgumentError.new("Col must be between 0 and 3") unless valid_pos?(col)

     placed_token = false

     last_empty_pos = -1

     board.each_with_index do |row, index|
       last_empty_pos = index if row[col] == '.'
     end

     if last_empty_pos != -1
       board[last_empty_pos][col] = token
       placed_token = true
     end

     placed_token
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

   def valid_pos?(col)
     return col.between?(0, 3)
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
       print("Enter col: ")

       col = gets.chomp

       begin
         token_placed = board.place_token(token, col.to_i) if judge.valid_move?(col.to_i)
       rescue ArgumenError => e
         puts('Choose another column')
       end

       break if token_placed
     end 
   end

   private
  
   attr_writer :name, :token
  end

  class ConnectFourJudge
    attr_reader :board, :player1, :player2

    def intialize(board, player1, player2)
      @board = board

      @player1 = player1

      @player2 = player2
    end

    def valid_move
    end

    def help
    end

    private

    attr_writer :board, :player1, :player2
  end
end
