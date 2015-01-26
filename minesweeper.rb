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

end
