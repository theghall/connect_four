# connect-four.spec
#
# 20170408 GH
require 'connect_four'

describe "ConnectFourBoard" do
  let(:c4_array) {Array.new(4) {Array.new(4, '.')}}
  let(:a_board) { ConnectFourBoard.new }

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
end
