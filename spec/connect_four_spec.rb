# connect-four.spec
#
# 20170408 GH
require 'connect_four'

describe "ConnectFourBoard" do
  let(:c4_array) {Array.new(4) {Array.new(4, '.')}}
  let(:a_board) { ConnectFour::ConnectFourBoard.new }

  context "Create a new ConnectFourBoard" do
    it "creates a 2x2 array with each element a '.'" do
      expect(a_board.board).to eql(c4_array)
    end
  end

  it {expect(a_board).to respond_to(:place_token)}
  it {expect(a_board).to respond_to(:display)}

  describe ".place_token" do
    context "Place any color token on column -1" do
      it "raise ArgumentError" do
         expect{a_board.place_token('B',-1)}.to raise_error(ArgumentError)
      end
    end

    context "Place any color token on column 4" do
      it "raises ArgumentError" do
         expect{a_board.place_token('B',4)}.to raise_error(ArgumentError)
      end
    end

    context "Place 'B' token on column 0 times" do
      it "returns 'true' and board[3][0] == 'B'" do
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[3][0]).to eql('B')
      end
    end

    context "Place 'B' token on column 0 2 times" do
      it "returns 'true' and board[2,0],[3][0] == 'B'" do
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[3][0]).to eql('B')
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[2][0]).to eql('B')
      end
    end

    context "Place 'B' token on column 0 3 times" do
      it "returns 'true' and board[1][0],[2][0],[3][0] == 'B'" do
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[3][0]).to eql('B')
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[2][0]).to eql('B')
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[1][0]).to eql('B')
      end
    end

    context "Place 'B' token on column 0 4 times" do
      it "returns 'true' and board[0][0],[1][0],[2][0],[3][0] == 'B'" do
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[3][0]).to eql('B')
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[2][0]).to eql('B')
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[1][0]).to eql('B')
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[0][0]).to eql('B')
      end
    end

    context "Place 'B' token on column 0 5 times" do
      it "returns 'false' after the fifth try" do
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.place_token('B',0)).to eql(false)
      end
    end
  end

  describe '.display' do
    context "Create a new board" do
      it "displays a 4 x 4 board of '.'" do
        expect{a_board.display}.to output("0123\n----\n....\n....\n....\n....\n").to_stdout
      end
    end
  end
end

describe "ConnectFourPlayer" do
  describe "attributes" do
    let(:a_player) { ConnectFour::ConnectFourPlayer.new('name', 't') }

    it {expect(a_player).to respond_to(:name)}
    it {expect(a_player).to respond_to(:take_turn)}
    it {expect(a_player).to respond_to(:token)}
  end

  describe ".name" do
    let(:a_player) {ConnectFour::ConnectFourPlayer.new('Gary', 'B')}

    context "construct a player with name 'Gary' and token'B'" do
      it "returns the name 'Gary' and token 'B'" do
        expect(a_player.name).to eql('Gary')
        expect(a_player.token).to eql('B')
      end
    end
  end

  describe ".take_turn" do
    let(:a_board) {ConnectFour::ConnectFourBoard.new}
    let(:a_player) {ConnectFour::ConnectFourPlayer.new('Gary', 'B')}

    context "enter a move that judge says is invalid" do

      it "asks for another move" do 
        a_judge = double('ConnectFourJudge')
        allow(a_judge).to receive(:valid_move?).and_return(false, true)
        allow(a_player).to receive(:gets).and_return('0','0')

        expect{a_player.take_turn(a_board, a_judge)}.to output(/That column is full, choose another/).to_stdout
      end
    end

    context "enter a valid move of column 0 4 time and token 'B', board is set correctly" do

      it "sets 3,0 to 'B'" do 
        a_judge = double('ConnectFourJudge')
        allow(a_judge).to receive(:valid_move?).and_return(true)
        allow(a_player).to receive(:gets).and_return('0')

        a_player.take_turn(a_board, a_judge)
        expect{a_board.display}.to output("0123\n----\n....\n....\n....\nB...\n").to_stdout
        a_player.take_turn(a_board, a_judge)
        expect{a_board.display}.to output("0123\n----\n....\n....\nB...\nB...\n").to_stdout
        a_player.take_turn(a_board, a_judge)
        expect{a_board.display}.to output("0123\n----\n....\nB...\nB...\nB...\n").to_stdout
        a_player.take_turn(a_board, a_judge)
        expect{a_board.display}.to output("0123\n----\nB...\nB...\nB...\nB...\n").to_stdout
      end
    end
  end
end

describe "ConnectFourJudge" do
 describe "Attributes" do
  let(:a_board) {ConnectFour::ConnectFourBoard.new}
  let(:player1) {ConnectFour::ConnectFourPlayer.new('John','B')}
  let(:player2) {ConnectFour::ConnectFourPlayer.new('Jane','R')}
  let(:a_judge) {ConnectFour::ConnectFourJudge.new(a_board, player1, player2)} 

  it {expect(a_judge).to respond_to(:judge_game)}
  it {expect(a_judge).to respond_to(:valid_move?)}
  it {expect(a_judge).to respond_to(:help)}
 end

 describe ".board" do
  let(:a_board) {ConnectFour::ConnectFourBoard.new}
  let(:player1) {ConnectFour::ConnectFourPlayer.new('John','B')}
  let(:player2) {ConnectFour::ConnectFourPlayer.new('Jane','R')}
  let(:a_judge) {ConnectFour::ConnectFourJudge.new(a_board, player1, player2)} 

  context "Create a new judge" do
    it "properly stores board object" do
      expect(a_judge.board).to eql(a_board)
    end
  end
 end

 describe ".player1" do
  let(:a_board) {ConnectFour::ConnectFourBoard.new}
  let(:player1) {ConnectFour::ConnectFourPlayer.new('John','B')}
  let(:player2) {ConnectFour::ConnectFourPlayer.new('Jane','R')}
  let(:a_judge) {ConnectFour::ConnectFourJudge.new(a_board, player1, player2)} 

  context "Create a new judge" do
    it "properly stores player1 object" do
      expect(a_judge.player1).to eql(player1)
    end
  end
 end

 describe ".player2" do
  let(:a_board) {ConnectFour::ConnectFourBoard.new}
  let(:player1) {ConnectFour::ConnectFourPlayer.new('John','B')}
  let(:player2) {ConnectFour::ConnectFourPlayer.new('Jane','R')}
  let(:a_judge) {ConnectFour::ConnectFourJudge.new(a_board, player1, player2)} 

  context "Create a new judge" do
    it "properly stores player2 object" do
      expect(a_judge.player2).to eql(player2)
    end
  end
 end

 describe ".help" do
  let(:a_board) {ConnectFour::ConnectFourBoard.new}
  let(:player1) {ConnectFour::ConnectFourPlayer.new('John','B')}
  let(:player2) {ConnectFour::ConnectFourPlayer.new('Jane','R')}
  let(:a_judge) {ConnectFour::ConnectFourJudge.new(a_board, player1, player2)} 

  context "when player asks for help" do
    it "dispalys help" do
      expect{a_judge.help}.to output("Connect four is a game in which two players\ntake turns placing their tokens at the top\nof one of four columns.  The player who\ngets 4 in a row horizontally, vertically or\ndiagonally wins the game. If all the tokens\nare placed then there is no winner and the\ngame is a draw.").to_stdout
    end
  end
 end

 describe ".valid_move" do
   let(:a_board) {ConnectFour::ConnectFourBoard.new}
   let(:player1) {ConnectFour::ConnectFourPlayer.new('John','B')}
   let(:player2) {ConnectFour::ConnectFourPlayer.new('Jane','R')}
   let(:a_judge) {ConnectFour::ConnectFourJudge.new(a_board, player1, player2)} 

   context "given empty board, placing a token in col 0" do
     it "returns true" do
       expect(a_judge.valid_move?(0)).to eql(true)
     end
   end

   context "given a full column 0, placing a token in col 0" do
     it "returns false" do
       a_board.place_token('B',0)
       a_board.place_token('B',0)
       a_board.place_token('B',0)
       a_board.place_token('B',0)
       expect(a_judge.valid_move?(0)).to eql(false)
     end
   end

   context "given an empty board, and column -1" do
     it "returns false" do
       expect(a_judge.valid_move?(-1)).to eql(false)
     end
   end

   context "given an empty board, and column 4" do
     it "returns false" do
       expect(a_judge.valid_move?(4)).to eql(false)
     end
   end
 end

 describe ".take_turn" do
   let(:a_board) {ConnectFour::ConnectFourBoard.new}
   let(:player1) {ConnectFour::ConnectFourPlayer.new('John','B')}
   let(:player2) {ConnectFour::ConnectFourPlayer.new('Jane','R')}
   let(:a_judge) {ConnectFour::ConnectFourJudge.new(a_board, player1, player2)} 

   context "Player1 choose column 0 four times and Player2 choses column 1 three times" do
     it "Player1 wins" do
       allow(player1).to receive(:gets).and_return('0')
       allow(player2).to receive(:gets).and_return('1')

       expect{a_judge.judge_game}.to output(/John is the winner!/).to_stdout
     end
   end

   context "Player1 choose column 1 four times and Player2 choses column 2 three times" do
     it "Player1 wins" do
       allow(player1).to receive(:gets).and_return('1')
       allow(player2).to receive(:gets).and_return('2')

       expect{a_judge.judge_game}.to output(/John is the winner!/).to_stdout
     end
   end

   context "Player1 choose column 2 four times and Player2 choses column 3 three times" do
     it "Player1 wins" do
       allow(player1).to receive(:gets).and_return('2')
       allow(player2).to receive(:gets).and_return('3')

       expect{a_judge.judge_game}.to output(/John is the winner!/).to_stdout
     end
   end

   context "Player1 choose column 3 four times and Player2 choses column 0 three times" do
     it "Player1 wins" do
       allow(player1).to receive(:gets).and_return('3')
       allow(player2).to receive(:gets).and_return('0')

       expect{a_judge.judge_game}.to output(/John is the winner!/).to_stdout
     end
   end
  end
end
