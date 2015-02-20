require_relative "pieces.rb"

class SlidingPiece < Piece

  attr_accessor :diagonals, :orthogonals

  def initialize(pos, board, color)
    super
  end

  def moves
    moves = []
    self.class.move_directions.each do |direction|
      moves += explore_direction(direction)
    end
    moves
  end

  def explore_direction(direction)
    moves_in_direction = []
    stop_search = false

    d_row, d_col = direction
    scalar = 1

    until stop_search
      offset = [d_row * scalar, d_col * scalar]

      new_pos = pos[0] + offset[0], pos[1] + offset[1]
      if Board.on_board?(new_pos)
        moves_in_direction << new_pos if (board[new_pos].nil? || board[new_pos].color != self.color)

        next_offset = [d_row * (scalar + 1), d_col * (scalar + 1)]
        next_pos = pos[0] + next_offset[0], pos[1] + next_offset[1]

        stop_search = true if !board[new_pos].nil? || !Board.on_board?(next_pos)
        scalar += 1
      else
        stop_search = true
      end
    end
    moves_in_direction
  end

end

class Queen < SlidingPiece

  def initialize(pos, board, color)
    super
    @symbol = self.color == :black ? :♛ : :♕
  end

  def self.move_directions
    ORTHOGONALS + DIAGONALS
  end

end

class Rook < SlidingPiece

  def initialize(pos, board, color)
    super
    @symbol = self.color == :black ? :♜ : :♖
  end

  def self.move_directions
    ORTHOGONALS
  end

end

class Bishop < SlidingPiece

  def initialize(pos, board, color)
    super
    @symbol = self.color == :black ? :♝ : :♗
  end

  def self.move_directions
    DIAGONALS
  end

end
