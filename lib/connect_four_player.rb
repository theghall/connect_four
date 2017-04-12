# player.rb
#
# 20170411	GH
#
class Player
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
