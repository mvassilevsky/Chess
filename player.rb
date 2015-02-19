require 'io/console'

class Player
  def play_turn
    raise NotImplementedError
  end
end

class HumanPlayer < Player

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    start_pos = get_start_pos(board)
    begin
      end_pos = get_end_pos(board)
      board.move(start_pos, end_pos)
    rescue ArgumentError => move_error
      error_prompt = move_error.message
      start_pos = get_start_pos(board, error_prompt)
      retry
    end
  end

  def get_start_pos(board, error_prompt = "")
    start_prompt = "Select the piece to move with spacebar. w-a-s-d move cursor, q to quit."
    input = get_input(board, start_prompt, error_prompt)

    if board[input].nil? || board[input].color != self.color
      error_prompt = "That's not your piece!"
      get_start_pos(board, error_prompt)
    else
      input
    end
  end

  def get_end_pos(board)
    end_prompt = "Select where to move piece with spacebar. w-a-s-d move cursor."
    input = get_input(board, end_prompt)

    input
  end

  def get_input(board, prompt, error_prompt = "")
    command = nil
    until command == ' '
      system('clear')
      board.render
      puts error_prompt
      puts prompt

      command = STDIN.getch
      case command
      when 'w' then board.cursor_pos[0] -= 1 unless board.cursor_pos[0] - 1 < 0
      when 's' then board.cursor_pos[0] += 1 unless board.cursor_pos[0] + 1 > 7
      when 'a' then board.cursor_pos[1] -= 1 unless board.cursor_pos[1] - 1 < 0
      when 'd' then board.cursor_pos[1] += 1 unless board.cursor_pos[1] + 1 > 7
      when 'q' then exit
      end
    end

    board.cursor_pos.dup
  end

end
