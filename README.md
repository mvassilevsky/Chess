# Chess

A simple command-line chess game written in Ruby. Pieces can be selected and
moved around with WASD.

## Instructions

If you don't already have the Colorize gem, run ```bundle install``` in the root folder of this application.
To play, run ```ruby lib/chess.rb```.

## Implementation

- chess.rb - launches the game and contains the main game loop
- board.rb - is the chessboard, populates itself with pieces, looks for check and checkmate
- pieces.rb - the basic Piece class, which looks for whether it moves into check, and implements the pawn
- sliding_piece.rb - implements the SlidingPiece class, which checks for valid moves in a certain direction; Queen, Rook, and Bishop inherit from it
- stepping_piece.rb - implements the SteppingPiece class, which implements part of the functionality for the King and Knight
- player.rb - gets the player's input and moves the piece on the board
