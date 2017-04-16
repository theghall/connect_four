# connect_four.rb
#
# 20170408	GH
#
require 'byebug'
module ConnectFour

  class ConnectFourBoard
    attr_reader :board

   def initialize
     @board = Array.new(6) {Array.new(7, '.')}
   end

   def place_token(token, col)
     raise ArgumentError.new("Col must be between 0 and 6") unless valid_pos?(col)

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
     puts("0123456")
     puts("-------")
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
     return col.between?(0, 6)
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
       print("#{name}, please enter col: ")

       col = gets.chomp

       begin
         token_placed = board.place_token(token, col.to_i) if judge.valid_move?(col.to_i)

         puts("That column is full, choose another.") unless token_placed
       rescue ArgumenError => e
         puts('Enter a valid column')
       end

       break if token_placed
     end 
   end

   private
  
   attr_writer :name, :token
  end

  class ConnectFourJudge
    attr_reader :board, :player1, :player2, :turn

    def initialize(board, player1, player2)
      @board = board

      @player1 = player1

      @player2 = player2

      @game_over = false

      @turn = 0

      @winner = false
    end

    def valid_move?(col)
      col.between?(0,6) && !col_full?(col) 
    end

    def officiate
      game_over = false

      winner = false

      active_player = player1

      while !game_over
        board.display

        active_player.take_turn(board, self)

        self.turn = self.turn + 1

        winner = winner?(active_player.token)

        draw = (turn == 16 && !winner)

        game_over = winner || draw

        active_player = (active_player == player1 ? player2 : player1) unless game_over
      end

      board.display

      if winner
        puts("#{active_player.name} is the winner!")
      else
        puts("The game is a draw!")
      end
    end

    def help
      puts <<END_HELP
Connect four is a game in which two players
take turns placing their tokens at the top
of one of four columns.  The player who
gets 4 in a row horizontally, vertically or
diagonally wins the game. If all the tokens
are placed then there is no winner and the
game is a draw.
END_HELP
    end

    private

    attr_accessor :winner, :game_over

    attr_writer :board, :player1, :player2, :turn

    def col_wins?(token)
      col_wins = false

      for x in 0..6
        num_in_col = board.board.flatten.each_with_index.select \
          { |t,i| t == token && (i == 0 + x || i == 7 + x || i == 14 + x \
                                 || i == 21 + x || i == 28 + x \
                                 || i == 35 + x) }.length

        col_wins = (num_in_col == 4)

        break if col_wins

      end

      col_wins
    end

    def row_wins?(token)
      row_wins = false

      regexp = token * 4

      board.board.each do |row|
        row_wins = !(row.join =~ /#{regexp}/).nil?

        break if row_wins
      end

      row_wins
    end

    def diagonal_wins?(token)
      diag_wins = false

      num_in_diagonal = board.board.flatten.each_with_index.select \
        { |t,i| t == token && (i == 0 || i == 5 || i == 10 || i == 15) }.length

      diag_wins = (num_in_diagonal == 4)

      if !diag_wins
        num_in_diagonal = board.board.flatten.each_with_index.select \
          { |t,i| t == token && (i == 3 || i == 6 || i == 9 || i == 12) }.length

        diag_wins = (num_in_diagonal == 4)
      end
         
      diag_wins
    end

    def winner?(token)
      winner = false

      winner ||= row_wins?(token)

      winner ||= col_wins?(token)

      winner ||= diagonal_wins?(token)

      winner
    end

    def col_full?(col)
      full = true

      board.board.each do |row|
        full &&= row[col] != '.'
      end

      full
    end
  end
end
