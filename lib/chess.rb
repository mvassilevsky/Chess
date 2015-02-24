require_relative 'pieces'
require_relative 'board'
require_relative "stepping_piece"
require_relative "sliding_piece"
require_relative "player"
require "colorize"

class Chess

attr_reader :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(:white)
    @player2 = HumanPlayer.new(:black)
  end

  def play
    puts "Game on!"
    while true
      break if @board.checkmate?(player1.color)
      turn(player1)
      break if @board.checkmate?(player2.color)
      turn(player2)
    end

    @board.render
    puts "Game over!"
  end

  def turn(player)
    puts "#{player.color} move: "
    player.play_turn(@board)
  end

end


game = Chess.new
game.play
