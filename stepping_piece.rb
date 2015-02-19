require_relative 'pieces.rb'

class SteppingPiece < Piece

  def initialize(pos, board, color)
    super
  end

  def moves
    @moves = []

    self.class.move_directions.each do |direction|
      new_pos = pos[0] + direction[0], pos[1] + direction[1]
      if Board.on_board?(new_pos)
        @moves << new_pos if board[new_pos].nil? || board[new_pos].color != self.color
      end
    end

    @moves
  end

end

class Knight < SteppingPiece

  def initialize(pos, board, color)
    super
    @symbol = self.color == :black ? :♞ : :♘
  end

  def self.move_directions
    [
      [2, 1],
      [1, 2],
      [-2, 1],
      [-1, 2],
      [2, -1],
      [1, -2],
      [-2, -1],
      [-1, -2]
    ]
  end
end

class King < SteppingPiece

  def initialize(pos, board, color)
    super
    @symbol = self.color == :black ? :♚ : :♔
  end

  def self.move_directions
    ORTHOGONALS + DIAGONALS
  end

end
