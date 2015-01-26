class Tile
  attr_reader :bomb

    def initialize
      @bomb = bomb?
      @revealed = false
      @flagged = false
    end

    def bomb?
      [true, false].sample
    end



end


class Board
  attr_reader :board

  def initialize
    @board = Array.new(9) {Array.new(9){Tile.new}}
  end

  def display
    @board.map do |row|
      puts "#{row.map do |tile|
        '*'
      end.join(' ')}"
    end
  end

  MOVES = [
    [1, -1],  [1, 0],  [1, 1],
    [0, -1],           [0, 1],
    [-1, -1], [-1, 0], [-1, 1]
  ]

  def make_move(move)
    action, position = move[0], move[1]
    tile = @board[position[0]][position[1]]

    tile.flagged = true if action == 'f'
    if action == 'r'
      game_over if tile.bomb

    end

  end

  def game_over

  end

end

class Game

  def initialize
    @game_on = true
    @board = Board.new
  end

  def play
    puts "Welcome to Minesweeper!"

    while @game_on

      @board.display

      move = get_move


    end

  end

  def get_move

    print "Flag or reveal? 'f' for flag, 'r' for reveal: "
    action = get_action

    puts "Where? Please use coordinates separated by a comma (i.e. '1,2')."
    position = get_position

    return [action, position]

  end

  def get_position
    while true
      ouput = gets.chomp.split(',')
      return output if output.all? { |coord| coord.between?(0,8) }
      puts "That is not a valid position."
    end
  end

  def get_action
    while true
      output = gets.chomp.downcase
      return output if output == 'f' || output == 'r'
      puts "That is not a valid action."
    end
  end

end
