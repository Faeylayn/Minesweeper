class Tile
  attr_reader :bomb
  attr_accessor :adjacent_bombs, :flagged, :revealed

  def initialize
    @bomb = bomb?
    @flagged = false
    @adjacent_bombs = nil
    @revealed = false
  end

  def bomb?
    [true, false, false].sample
  end
end


class Board
  attr_reader :board, :game_over

  def initialize
    @board = Array.new(9) {Array.new(9){Tile.new}}
    @game_over = false
    @num_bombs = count_bombs
    @bombs_found = 0
    @flag_count = 0
    calculate_adjacent_bombs
  end

  def count_bombs
    count = 0

    each_tile do |tile|
      count += 1 if tile.bomb
    end

    count
  end

  def display
    puts "  #{(0..8).to_a.join(' ')}"
    @board.map.with_index do |row, idx|
      puts "#{idx} #{row.map do |tile|
        if tile.flagged
          'F'
        elsif tile.revealed == false
          '*'
        elsif tile.adjacent_bombs == 0
          '_'
        else
          "#{tile.adjacent_bombs}"
        end
      end.join(' ')}"
    end

    puts "You have placed #{@flag_count} flags for #{@num_bombs} bombs."
  end

  MOVES = [
    [-1, -1], [-1, 0], [-1, 1],
    [ 0, -1],          [ 0, 1],
    [ 1, -1], [ 1, 0], [ 1, 1]
  ]

  def make_move(move)
    action, position = move[0], move[1]
    tile = @board[position[0]][position[1]]

    if action == 'f'
      unless tile.flagged
        @flag_count += 1
        @bombs_found += 1 if tile.bomb
      end

      tile.flagged = true
    elsif action == 'r'
      @game_over = true if tile.bomb
      tile.revealed = true
      reveal_adjacent_tiles(position) if tile.adjacent_bombs == 0
    elsif action == 'u'
      if tile.flagged
        @flag_count -= 1
        @bombs_found -= 1 if tile.bomb
      end
      tile.flagged = false
    end
  end

  def reveal_adjacent_tiles(position)

    MOVES.each do |dx, dy|
      tester = [position[0] + dx, position[1] + dy]
      next unless within_bounds?(tester)
      current_tile = @board[tester[0]][tester[1]]
      next if current_tile.revealed

      current_tile.revealed = true

      reveal_adjacent_tiles(tester) if current_tile.adjacent_bombs == 0
    end

  end

  def bombs_adjacent_to(position)
    count = 0

    MOVES.each do |dx, dy|
      tester = [position[0] + dx, position[1] + dy]
      next unless within_bounds?(tester)
      count += 1 if @board[tester[0]][tester[1]].bomb
    end

    count
  end

  def found_all_bombs?
    each_tile do |tile|
      return false if !tile.flagged && tile.bomb
      return false if tile.flagged && !tile.bomb
    end

    @num_bombs == @bombs_found
  end

  def calculate_adjacent_bombs
     @board.each_with_index do |row, idx|
       row.each_with_index do |tile, jdx|
         tile.adjacent_bombs = bombs_adjacent_to([idx, jdx])
       end
     end
  end

  def within_bounds?(position)
    position.all? { |coord| coord.between?(0, 8) }
  end

  def each_tile(&prc)
    @board.each do |row|
      row.each do |tile|
        prc.call(tile)
      end
    end
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
      if @board.found_all_bombs?
        puts "You win! Congrats."
        @game_on = false
        @board.display
      end

    end

  end

  def get_move

    print "Flag or reveal? 'f' for flag, 'r' for reveal, 'u' for unflag: "
    action = get_action

    puts "Where? Please use coordinates separated by a comma (i.e. '1,2')."
    position = get_position

    return [action, position]

  end

  def get_position
    while true
      output = gets.chomp.split(',').map(&:to_i)
      return output if output.all? { |coord| coord.between?(0,8) }
      puts "That is not a valid position."
    end
  end

  def get_action
    while true
      output = gets.chomp.downcase
      return output if ['f', 'r', 'u'].include?(output)
      puts "That is not a valid action."
    end
  end

end
