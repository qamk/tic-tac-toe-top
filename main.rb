require_relative 'tic_tac_toe.rb'

# Interface for tic tac toe
class Main
  def initialize
    game = TicTacToe.new
    game.name_players
    game.make_grid
    game.play
  end
end
Main.new