# player_spec.rb
#
# 20170411	GH
#
require 'connect_four_player'

describe "ConnectFourPlayer" do
  describe "attributes" do
    let(:a_player) { Player.new }

    it {expect(a_player).to respond_to(:name)}
    it {expect(a_player).to respond_to(:take_turn)}
  end
end
