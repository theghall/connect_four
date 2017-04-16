require './connect_four'

player1 = ConnectFour::ConnectFourPlayer.new("John", "B")
player2 = ConnectFour::ConnectFourPlayer.new("Jane", "R")

board = ConnectFour::ConnectFourBoard.new

judge = ConnectFour::ConnectFourJudge.new(board, player1, player2)

judge.officiate

