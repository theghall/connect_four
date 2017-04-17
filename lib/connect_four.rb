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
     input = nil

     loop do
       puts('You can enter /help or /quit at anytime.')

       print("#{name}, please enter col: ")

       input = gets.chomp.downcase

       valid_command = valid_command?(input) if input[0].eql?('/')

       if !valid_command
         begin
           token_placed = judge.place_piece(token, input.to_i)

           puts("That column is full, choose another.") unless token_placed
         rescue ArgumenError => e
           puts('Enter a valid column')
         end
       else
         ask_again = judge.do_command(input[1..-1])
       end

       break if token_placed || !ask_again
     end 

     input.to_i
   end

   private
  
   attr_writer :name, :token

   def valid_command?(command)
     command = command[1..-1]

     %w(help quit).include?(command)
   end
  end

  class ConnectFourJudge
    attr_reader :board, :player1, :player2, :active_player, :turn

    def initialize(board, player1, player2)
      @board = board

      @player1 = player1

      @player2 = player2
      
      @active_player = player1

      @game_over = false

      @player_quit = false

      @turn = 0

      @winner = false
    end

    def valid_move?(col)
      col.between?(0,6) && !col_full?(col) 
    end

    def officiate
      winner = false

      draw = false

      active_player = player1

      while !game_over?
        board.display

        col = active_player.take_turn(board, self)

        if !player_quit
          self.turn = self.turn + 1

          winner = winner?(active_player.token, col)

          draw = (turn == 42 && !winner)
        end

        self.game_over = winner || draw || player_quit

        active_player = (active_player == player1 ? player2 : player1) unless game_over
      end

      board.display

      if winner
        puts("#{active_player.name} is the winner!")
      elsif draw
        puts("The game is a draw!")
      else
        puts("#{active_player.name}, thanks for playing!")
      end
    end

    def place_piece(token, col)
      place_piece = false

      if valid_move?(col)
        board.place_token(token, col)
        place_piece = true
      end

      place_piece
    end

    def do_command(command)
      ask_again = false

      case command
      when "help"
        self.help
        ask_again = true
      when "quit"
        self.quit
        ask_again = false
      end

      ask_again
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

    def quit
      @player_quit = true
    end

    private

    attr_accessor :winner, :game_over, :player_quit

    attr_writer :board, :player1, :player2, :active_player, :turn

    def game_over?
      game_over == true
    end

    def col_wins?(token, col)
      col_wins = false

      regexp = token * 4

      col_string = ''
      (0..5).each do |row|
        col_string += board.board[row][col]
      end

      col_wins = !(col_string =~ /#{regexp}/).nil?
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

    def normalize_up(num)
      num < 0 ? 0 : num
    end

    def normalize_down(num, target)
      num > target ? target : num
    end

    def get_diag_dir1(row, col)
      crow = srow = normalize_up(row - 3)

      ccol = scol = normalize_up(col - 3)

      # :TODO fix so ccol not > 6
      erow = normalize_down(row + 3, 5)

      diag = "" 

      while crow <= erow do
        diag += board.board[crow][ccol]

        crow += 1

        ccol += 1
        
        break if ccol > 6
      end

      diag
    end

    def get_diag_dir2(row, col)
      crow = srow = normalize_down(row + 3, 5)

      ccol = scol = normalize_up(col - 3)

      # :TODO fix so ccol not > 6
      erow = normalize_up(row - 3)

      diag = "" 

      while crow >= erow do
        diag += board.board[crow][ccol]

        crow -= 1

        ccol += 1

        break if ccol > 6
      end

      diag
    end

    def check_diag(token, diag)

      regexp = token * 4

      diag_wins = !(diag =~ /#{regexp}/).nil?
    end

    def diagonal_wins?(token, col)
      diag_wins = false

      row = find_top_row(col)

      diag_wins = check_diag(token, get_diag_dir1(row, col))
       
      diag_wins ||= check_diag(token, get_diag_dir2(row,col))
    end

    def find_top_row(col)
      crow = 5

      (0..6).each do |row|
        crow = row
        break if board.board[row][col] != '.'
      end

      crow
    end

    def winner?(token, col)
      winner = false

      winner ||= row_wins?(token)

      winner ||= col_wins?(token, col)

      winner ||= diagonal_wins?(token, col)

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
