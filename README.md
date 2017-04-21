# connect_four
Connect Four is a game played traditionally with a 7 x 6 upright playing area.  Players alternately drop their tokens, red and black, into one of the columns at the top of the playing area. When a player gets 4 in a row horizontally, vertically, or diagonally they win.  If all the tokens are placed without 4 in a row then the game is a drawer.

This repo consists of one module: connect_four.rb (and its accompyaning spec: connect_four_spec.rb).  It contains three classes: ConnectFourBoard, ConnectFourPlayer, and ConnectFourJudge.
To use create the following four objects:
board = ConnnectFour::ConnenctFourBoard#new
player1 = ConnectFour::ConnectFourPlayer(<Name1>,'B')
player2 = ConnectFour::ConnectFourPlayer(<Name2>, 'R')
judge = ConnectFour::ConnectFourJudge(board, player1, player2)

Then to start game:
judge#officiate

The main point of this exercise was to use BDD; for simplicity sake no base classes were created.  The code can use some optimiztion but I am moving on.
