class Tile
  attr_reader :bomb
  attr_accessor :adjacent_bombs, :flagged

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
    @flag_count = 0
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
    puts "  #{(0..8).to_a.join(' ')}"
    @board.map.with_index do |row, idx|
      puts "#{idx} #{row.map do |tile|
        if tile.flagged
          'F'
        elsif tile.adjacent_bombs.nil?
          '*'
        elsif tile.adjacent_bombs == 0
          '_'
        else
          "#{tile.adjacent_bombs}"
        end
      end.join(' ')}"
    end

    puts "You have placed #{@flag_count} flags for #{@num_bombs}."
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
      tile.adjacent_bombs = bombs_adjacent_to(position)
    elsif action == 'u'
      if tile.flagged
        @flag_count -= 1
        @bombs_found -= 1 if tile.bomb
      end
      tile.flagged = false
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

  def found_all_bombs?
    @board.each do |row|
      row.each do |tile|
        return false if !tile.flagged && tile.bomb
        return false if tile.flagged && !tile.bomb
      end
    end

    @num_bombs == @bombs_found
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
