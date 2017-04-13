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
    context "Place any color token on -1,1" do
      it "raise ArgumentError" do
         expect{a_board.place_token('B',-1,1)}.to raise_error(ArgumentError)
      end
    end

    context "Place any color token on 1,-1" do
      it "raises ArgumentError" do
         expect{a_board.place_token('B',1,-1)}.to raise_error(ArgumentError)
      end
    end

    context "Place any color token on 5,1" do
      it "raises ArgumentError" do
         expect{a_board.place_token('B',5,1)}.to raise_error(ArgumentError)
      end
    end

    context "Place any color token on 1,5" do
      it "raise ArgumentEror" do
         expect{a_board.place_token('B',1,5)}.to raise_error(ArgumentError)
      end
    end

    context "Place 'B' token on 1,1" do
      it "returns 'true' and board[1][1] == 'B'" do
        expect(a_board.place_token('B',1,1)).to eql(true)
        expect(a_board.board[1][1]).to eql('B')
      end
    end
  end

  describe '.display' do
    context "Create a new board" do
      it "displays a 4 x 4 board of '.'" do
        expect{a_board.display}.to output("....\n....\n....\n....\n").to_stdout
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

#    Loop probably prevents this test from working
#
#    context "enter a move that judge says is invalid" do
#
#      it "asks for another move" do 
#        a_judge = double('ConnectFourJudge')
#        allow(a_judge).to receive(:valid_move?).and_return(false)
#        allow(a_player).to receive(:gets).and_return('0,0')
#
#        expect{a_player.take_turn(a_board, a_judge)}.to output('Choose another position').to_stdout
#      end
#    end

    context "enter a valid move of 0,0 and token 'B', board is set correctly" do

      it "sets 0,0 to 'B'" do 
        a_judge = double('ConnectFourJudge')
        allow(a_judge).to receive(:valid_move?).and_return(true)
        allow(a_player).to receive(:gets).and_return('0,0')

        a_player.take_turn(a_board, a_judge)
        expect{a_board.display}.to output("B...\n....\n....\n....\n").to_stdout
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
  it {expect(a_judge).to respond_to(:valid_move)}
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
      expect(a_judge.player1).to eql(player2)
    end
  end
 end
end
