# connect-four.spe
# 20170408 GH
require 'connect_four'

describe "ConnectFourBoard" do
  let(:c4_array) {Array.new(6) {Array.new(7, '.')}}
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
         expect{a_board.place_token('B',7)}.to raise_error(ArgumentError)
      end
    end

    context "Place 'B' token on column 0 times" do
      it "returns 'true' and board[3][0] == 'B'" do
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.board[5][0]).to eql('B')
      end
    end

    context "Place 'B' token on column 0 6 times" do
      it "returns 'false' after the sixth try" do
        expect(a_board.place_token('B',0)).to eql(true)
        expect(a_board.place_token('B',0)).to eql(true)
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
        expect{a_board.display}.to output("0123456\n-------\n.......\n.......\n.......\n.......\n.......\n.......\n").to_stdout
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
    let(:player1) {ConnectFour::ConnectFourPlayer.new('John', 'B')}
    let(:player2) {ConnectFour::ConnectFourPlayer.new('Jane', 'R')}
    let(:a_judge) {ConnectFour::ConnectFourJudge.new(a_board, player1, player2)}

    context "enter a move that judge says is invalid" do

      it "asks for another move" do 
        allow(a_judge).to receive(:valid_move?).and_return(false, true)
        allow(player1).to receive(:gets).and_return('0','0')

        expect{player1.take_turn(a_board, a_judge)}.to output(/That column is full, choose another/).to_stdout
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

  it {expect(a_judge).to respond_to(:officiate)}
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
       allow(player1).to receive(:gets).and_return('/help','/quit')

      expect{a_judge.officiate}.to output(/Connect four is a game in which two players\ntake turns placing their tokens at the top\nof one of four columns.  The player who\ngets 4 in a row horizontally, vertically or\ndiagonally wins the game. If all the tokens\nare placed then there is no winner and the\ngame is a draw./).to_stdout
    end
  end
 end

 describe ".quit" do
  let(:a_board) {ConnectFour::ConnectFourBoard.new}
  let(:player1) {ConnectFour::ConnectFourPlayer.new('John','B')}
  let(:player2) {ConnectFour::ConnectFourPlayer.new('Jane','R')}
  let(:a_judge) {ConnectFour::ConnectFourJudge.new(a_board, player1, player2)} 

   context "when player1 quits" do
     it "displays 'John, thanks for playing.'" do
       allow(player1).to receive(:gets).and_return('/quit')

       expect(a_judge.officiate).to output("John, thanks for playing\n")
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

   context "given an empty board, and column 7" do
     it "returns false" do
       expect(a_judge.valid_move?(7)).to eql(false)
     end
   end
 end

 describe ".officiate" do
   let(:a_board) {ConnectFour::ConnectFourBoard.new}
   let(:player1) {ConnectFour::ConnectFourPlayer.new('John','B')}
   let(:player2) {ConnectFour::ConnectFourPlayer.new('Jane','R')}
   let(:a_judge) {ConnectFour::ConnectFourJudge.new(a_board, player1, player2)} 

   context "A sequence of moves that gives player 1 a win in row 1" do
     it "Player1 wins" do
       allow(player1).to receive(:gets).and_return('0','1','2','3')
       allow(player2).to receive(:gets).and_return('0','1','2')

       expect{a_judge.officiate}.to output(/John is the winner!/).to_stdout
     end
   end

   context "given a sequence of moves with 4 of same token in one row, non-consecutive" do
     it "does not result in a win" do
       allow(player1).to receive(:gets).and_return('0','2','4','6')
       allow(player2).to receive(:gets).and_return('1','3','5','/quit')

       expect{a_judge.officiate}.to output(/Jane, thanks for playing/)
     end
   end

   context "A sequence of moves that gives player1 a win in col 0" do
     it "Player1 wins" do
       allow(player1).to receive(:gets).and_return('0','0','0','0')
       allow(player2).to receive(:gets).and_return('1','1','1')

       expect{a_judge.officiate}.to output(/John is the winner!/).to_stdout
     end
   end

   context "given a sequence of moves with 4 of same token in one column, non-consecutive" do
     it "does not result in a win" do
       allow(player1).to receive(:gets).and_return('0','0','0','0')
       allow(player2).to receive(:gets).and_return('0','0','0','/quit')

       expect{a_judge.officiate}.to output(/Jane, thanks for playing/)
     end
   end

   context "given a sequence of moves that gives player1 a diagonal win, left down to right" do
     it "Player1 wins" do
       allow(player1).to receive(:gets).and_return('0','1','2','2','3','3')
       allow(player2).to receive(:gets).and_return('1','2','3','3','4')

       expect{a_judge.officiate}.to output(/John is the winner!/).to_stdout
     end
   end

   context "given a sequence of moves that gives player1 a diagonal win, right down to left" do
     it "Player1 wins" do
       allow(player1).to receive(:gets).and_return('6','5','4','4','3','3')
       allow(player2).to receive(:gets).and_return('5','4','3','3','0')

       expect{a_judge.officiate}.to output(/John is the winner!/).to_stdout

     end
   end

  context "given a sequence of moves, 4 non-consective equal tokens" do
    it "does not give a win" do
       allow(player1).to receive(:gets).and_return('0','2','2','2','3','4','4','4','5','5','5')
       allow(player2).to receive(:gets).and_return('1','1','3','3','3','4','4','5','5','5','/quit')

       expect{a_judge.officiate}.to output(/Jane, thanks for playing/).to_stdout
    end
  end

  context "given a sequence of moves that ends in a draw" do
    it "displays 'The game is a draw'" do
       allow(player1).to receive(:gets).and_return('0','0','0','6','1','1','1','2','2','2','6','3','3','3','4','4','4','6','5','5','5')
       allow(player2).to receive(:gets).and_return('0','0','0','1','1','1','6','2','2','2','3','3','3','6','4','4','4','5','5','5','6')

       expect{a_judge.officiate}.to output(/The game is a draw/).to_stdout
    end
  end
 end
end
