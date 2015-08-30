require_relative 'board.rb'
require 'colorize'

class MinesweeperTile
  attr_accessor :bombed
  attr_reader :flagged, :revealed

  DELTA_POS = [[-1, -1],
  [-1, 0],
  [-1, 1],
  [0, -1],
  [0, 1],
  [1, -1],
  [1, 0],
  [1, 1]]

  def initialize(pos, bombed)
    @bombed, @pos, @flagged, @revealed,
    @neighbors_bomb_count, @neighbors = bombed, pos, false, false, 0, []
  end

  def reveal(board, last_pos = nil)
    if flagged || revealed
      puts "you can't reveal that tile" unless last_pos
      return
    end
    #set reveal to true, return neighbor_bomb count, or blow you up if bomb
    @revealed = true
    return :boom if @bombed
    neighbors(board)
    neighbor_bomb_count
    if @neighbor_bomb_count.zero?
      @neighbors.each do |neighbor|
        #unless neighbor == last_pos
        #we added the || revealed? above after putting
        #that quit in, so we don't need last_pos to avoid repeating tiles.
           neighbor.reveal(board,self)
        #  end
       end
    end
  end

  def flag
    #return if revealed
    # @flagged ? @flagged = false : @flagged = true
    #this is much simpler:
    @flagged = !@flagged unless revealed
  end

  def neighbors(board)
    #rewrote on 1 line by combining array.new, and each do arr << result
    adjacent_positions = DELTA_POS.map { |delta| [delta[0] + @pos[0], delta[1] + @pos[1]] }
    # adjacent_positions << [@pos[0] - 1, @pos[1] - 1]
    # adjacent_positions << [@pos[0] - 1, @pos[1]]
    # adjacent_positions << [@pos[0] - 1, @pos[1] + 1]
    # adjacent_positions << [@pos[0], @pos[1] - 1]
    # adjacent_positions << [@pos[0], @pos[1] + 1]
    # adjacent_positions << [@pos[0] + 1, @pos[1] - 1]
    # adjacent_positions << [@pos[0] + 1, @pos[1]]
    # adjacent_positions << [@pos[0] + 1, @pos[1] + 1]

    adjacent_positions.select! do |pos|
      pos[0].between?(0,board.grid.length - 1) && pos[1].between?(0,board.grid.length - 1)
    end
    #create array of adjacent tiles
    #new tiles for each neighbor

    #switched do/end to []
    adjacent_positions.each { |position| @neighbors << board[position] }
  end

  def neighbor_bomb_count
    #reveals adjacent tiles, counts bombs
    @neighbor_bomb_count = 0
    @neighbors.each do |tile|
      @neighbor_bomb_count += 1 if tile.bombed
    end
  end

  def value
    #rewrote without returns. A ternary operator helped.
    if flagged
      "F".colorize(:red).colorize(:background => :black)
    elsif revealed
      bombed  ? "*".colorize(:yellow).colorize : @neighbor_bomb_count.to_s.colorize(:blue)
    else
      "-".colorize(:black)
    end
  end

  def bombed?
    return nil unless self.revealed
    bombed
  end
end
