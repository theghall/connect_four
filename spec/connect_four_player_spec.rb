# player_spec.rb
#
# 20170411	GH
#
require 'connect_four_player'
require 'connect_four_board'

describe "ConnectFourPlayer" do
  describe "attributes" do
    let(:a_player) { Player.new('name', 't') }

    it {expect(a_player).to respond_to(:name)}
    it {expect(a_player).to respond_to(:take_turn)}
    it {expect(a_player).to respond_to(:token)}
  end

  describe ".name" do
    let(:a_player) {Player.new('Gary', 'B')}

    context "construct a player with name 'Gary' and token'B'" do
      it "returns the name 'Gary' and token 'B'" do
        expect(a_player.name).to eql('Gary')
        expect(a_player.token).to eql('B')
      end
    end
  end

  describe ".take_turn" do
    let(:a_board) {ConnectFourBoard.new}
    let(:a_player) {Player.new('Gary', 'B')}

    context "enter a move that judge says is invalid" do

      it "asks for another move" do 
        a_judge = double('ConnectFourJudge')
        allow(a_judge).to receive(:valid_move?).and_return(false)
        allow(a_player).to receive(:gets).and_return('0,0')

        expect{a_player.take_turn(a_board, a_judge)}.to output('Choose another position').to_stdout
      end
    end

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
