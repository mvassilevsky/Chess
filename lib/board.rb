class Board

  attr_reader :rows
  attr_accessor :cursor_pos

  def initialize(populate = true)
    @rows = Array.new(8) { Array.new(8) }
    @cursor_pos = [7, 0]

    populate_board if populate
  end

  def [](pos)
    row, col = pos
    @rows[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @rows[row][col] = piece
  end

  def self.on_board?(pos)
    pos[0] >= 0 && pos[0] <= 7 && pos[1] >= 0 && pos[1] <= 7
  end

  def populate_board
    #black pieces
    black_pieces_seed = {
      [0, 0] => Rook.new([0, 0], self, :black),
      [0, 1] => Knight.new([0, 1], self, :black),
      [0, 2] => Bishop.new([0, 2], self, :black),
      [0, 3] => Queen.new([0, 3], self, :black),
      [0, 4] => King.new([0, 4], self, :black),
      [0, 5] => Bishop.new([0, 5], self, :black),
      [0, 6] => Knight.new([0, 6], self, :black),
      [0, 7] => Rook.new([0, 7], self, :black),
      [1, 0] => Pawn.new([1, 0], self, :black),
      [1, 1] => Pawn.new([1, 1], self, :black),
      [1, 2] => Pawn.new([1, 2], self, :black),
      [1, 3] => Pawn.new([1, 3], self, :black),
      [1, 4] => Pawn.new([1, 4], self, :black),
      [1, 5] => Pawn.new([1, 5], self, :black),
      [1, 6] => Pawn.new([1, 6], self, :black),
      [1, 7] => Pawn.new([1, 7], self, :black)
    }

    #white pieces
    white_pieces_seed = {
      [7, 0] => Rook.new([7, 0], self, :white),
      [7, 1] => Knight.new([7, 1], self, :white),
      [7, 2] => Bishop.new([7, 2], self, :white),
      [7, 3] => Queen.new([7, 3], self, :white),
      [7, 4] => King.new([7, 4], self, :white),
      [7, 5] => Bishop.new([7, 5], self, :white),
      [7, 6] => Knight.new([7, 6], self, :white),
      [7, 7] => Rook.new([7, 7], self, :white),
      [6, 0] => Pawn.new([6, 0], self, :white),
      [6, 1] => Pawn.new([6, 1], self, :white),
      [6, 2] => Pawn.new([6, 2], self, :white),
      [6, 3] => Pawn.new([6, 3], self, :white),
      [6, 4] => Pawn.new([6, 4], self, :white),
      [6, 5] => Pawn.new([6, 5], self, :white),
      [6, 6] => Pawn.new([6, 6], self, :white),
      [6, 7] => Pawn.new([6, 7], self, :white)
    }

    black_pieces_seed.each do |pos, piece|
      self[pos] = piece
    end

    white_pieces_seed.each do |pos, piece|
      self[pos] = piece
    end

    self
  end

  def in_check?(color)
    king_pos = find_king_pos(color)
    other_color = color == :black ? :white : :black
    enemy_pieces = find_pieces(other_color)
    enemy_pieces.any? do |piece|
      piece.moves.include?(king_pos)
    end
  end

  def find_pieces(color)
    self.rows.flatten.compact.select { |piece| piece.color == color }
  end

  def find_king_pos(color)
    pieces = find_pieces(color)
    king = pieces.find { |piece| piece.is_a?(King) }
    king.pos
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]

    raise ArgumentError, "Can't move to this position" unless piece.valid_moves.include?(end_pos)

    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = nil

    true
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]
    raise ArgumentError, "Can't move to this position" unless piece.moves.include?(end_pos)
    self[end_pos] = piece
    self[start_pos] = nil
    piece.pos = end_pos

    true
  end

  def dup
    copy_board = Board.new(false)

    (0..7).each do |row_index|
      (0..7).each do |col_index|
        pos = [row_index, col_index]
        next if self[pos].nil?

        piece = self[pos]
        color = piece.color
        dup_piece = piece.class.new(pos, copy_board, color)

        copy_board[pos] = dup_piece
      end
    end

    copy_board
  end

  def checkmate?(color)
    pieces = find_pieces(color)
    pieces.all? { |piece| piece.valid_moves.none? }
  end

  def render
    column_labels = "  a  b  c  d  e  f  g  h"
    puts
    puts column_labels
    rows.each_with_index do |row, row_index|
      print (8 - row_index).to_s + ' '
      row.each_with_index do |element, col_index|
        if [row_index, col_index] == cursor_pos
          print_element(element, true)
        else
          print_element(element)
        end
      end
      print (8 - row_index).to_s
      puts
    end
    puts column_labels
  end


  def print_element(element, colorize = false)
    if element.is_a?(Piece)
      string_element = element.symbol.to_s + "  "
    else
      string_element = "_  "
    end

    print string_element.colorize(:background => :blue) if colorize
    print string_element if !colorize
  end

end
