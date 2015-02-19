require_relative "board"

class Piece
  attr_accessor :pos, :board, :color, :moves, :symbol

  DIAGONALS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  ORTHOGONALS = [[0, 1], [1, 0], [0, -1], [-1, 0]]

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def inspect
    self.symbol
  end

  def valid_moves
    moves.select { |move| !move_into_check?(move) }
  end

  def move_into_check?(end_pos)
    copy_board = board.dup
    copy_board.move!(self.pos, end_pos)
    copy_board.in_check?(color)
  end

end

class Pawn < Piece

  attr_reader :has_moved

  def initialize(pos, board, color)
    super
    @has_moved = false
    @symbol = self.color == :black ? :♟ : :♙
  end

  def pos=(pos)
    @pos = pos
    @has_moved = true
  end

  def self.straight_directions(color)
    black_straight_dirs = [ [1, 0], [2, 0] ]
    white_straight_dirs = [ [-1, 0], [-2,0] ]

    return black_straight_dirs if color == :black
    white_straight_dirs
  end

  def self.attack_directions(color)
    black_attack_dirs = [ [1, 1], [1, -1] ]
    white_attack_dirs = [ [-1, 1], [-1, -1] ]

    return black_attack_dirs if color == :black
    white_attack_dirs
  end

  def moves
    @moves = get_straight_moves + get_diag_moves
    @moves
  end

  def get_straight_moves
    straight_moves = []
    self.class.straight_directions(self.color).each do |direction|
      new_pos = pos[0] + direction[0], pos[1] + direction[1]

      if Board.on_board?(new_pos) && board[new_pos].nil?
        if direction[0].abs == 1
          straight_moves << new_pos
        elsif direction[0].abs == 2 && self.has_moved == false
          one_row_forward = self.color == :black ? 1 : -1
          position_in_front = pos[0] + one_row_forward , pos[1]
          straight_moves << new_pos if board[position_in_front].nil?
        end
      end
    end
    straight_moves
  end

  def get_diag_moves
    diag_moves = []
    self.class.attack_directions(self.color).each do |direction|
      new_pos = pos[0] + direction[0], pos[1] + direction[1]
      next if !Board.on_board?(new_pos) || board[new_pos].nil?

      diag_moves << new_pos if board[new_pos].color != self.color
    end
    diag_moves
  end

end
