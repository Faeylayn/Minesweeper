class Tile
  attr_reader :bomb
  attr_accessor :adjacent_bombs

    def initialize
      @bomb = bomb?
      @flagged = false
      @adjacent_bombs = nil
    end

    def bomb?
      [true, false].sample
    end




end


class Board
  attr_reader :board, :game_over

  def initialize
    @board = Array.new(9) {Array.new(9){Tile.new}}
    @game_over = false
    @num_bombs = count_bombs
    @bombs_found = 0
  end

  def count_bombs
    count = 0

    @board.each do |row|
      row.each do |tile|
        count += 1 if tile.bomb
      end
    end

    count
  end

  def display
    @board.map do |row|
      puts "#{row.map do |tile|
        'F' if tile.flagged
        '*' if tile.adjacent_bombs.nil?
        '_' if tile.adjacent_bombs == 0
        "#{tile.adjacent_bombs}" if tile.adjacent_bombs.between?(1,8)
      end.join(' ')}"
    end

    puts "You have found #{@bombs_found} / #{@num_bombs}."
  end

  MOVES = [
    [-1, -1],  [-1, 0],  [-1, 1],
    [0, -1],           [0, 1],
    [1, -1], [1, 0], [1, 1]
  ]

  def make_move(move)
    action, position = move[0], move[1]
    tile = @board[position[0]][position[1]]

    tile.flagged = true if action == 'f'
    if action == 'r'
      @game_over = true if tile.bomb
      tile.adjacent_bombs = bombs_adjacent_to(position)
    end
  end

  def bombs_adjacent_to(position)
    count = 0

    MOVES.each do |x, y|
      tester = [position[0] + x, position[1] + y]
      next unless tester.all?{|coord| coord.between?(0, 8)}
      count += 1 if @board[tester[0]][tester[1]].bomb
    end

    count
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
      @board.make_move(move)
      if @board.game_over
        @game_on = false
        puts "You lose! #{move[1]} was a bomb."
        @board.display
      end


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
