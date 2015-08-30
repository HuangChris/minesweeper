require "byebug"
require_relative "tile.rb"
require 'colorize'

class Board
  attr_reader :size, :grid, :bombs

  def initialize(size = 9, bombs = 10)
    @bombs, @size = bombs, size
    @grid = Array.new(size) {Array.new(size)}
    populate
  end

  def populate
    #generate tiles for each square on grid and assign to grid.
    #call neighbors on each tile.

    size.times do |row|
      size.times do |col|
        # @grid[row][col] = MinesweeperTile.new([row, col], false)
        pos = [row,col]
        self[pos] = MinesweeperTile.new(pos, false)
      end
    end

    random
  end

  def render
    print " "
    (0...@grid.length).each { |el| print el.to_s + " " }
    print "\n"
    @grid.each_with_index do |row, row_idx|
      print row_idx.to_s
      row.each_with_index do |col, col_idx|
        print col.value + " ".colorize(:background => :black)
      end
      print "\n"
    end
  end

  #solution adds a #reveal method to return all tiles at end of game.
    #could just make it reveal all tiles, then call render.

  def random
    #assign bombs to random tiles
    bombs_assigned = 0
    until bombs_assigned == bombs
      pos = [rand(size),rand(size)]
      #pos = Array.new (2) {rand(size)} this is the solution;
      #it does the same and saves almost nothing; i suppose it does DRY
      next if self[pos].bombed
      self[pos].bombed = true
      bombs_assigned += 1
    end
  end

  #solution uses won/lost, not over/won. means a double condition on
  #game.run loop, but much simpler conditions for lost vs over.
  def game_over?
    #return true if a bomb tile is revealed, or board_won?
    @grid.each do |row|
      row.each do |tile|
        return true if tile.revealed && tile.bombed?
      end
    end

    # @grid.flatten.any? {|tile| tile.bombed? && tile.revealed}

    return true if board_won?
    false
  end

  def board_won?
    #return true if all tiles revealed or flagged, and no false_flags
    #solution win_condition is all bombs are either revealed or bombed, not both.
    #that works because flagged and revealed should be exclusive.
    @grid.all? do |row_of_tiles|
      row_of_tiles.all? do |tile|

        if tile.revealed
          true
        elsif tile.flagged && tile.bombed
          true
        else
          false
        end
      end
    end
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []= (pos, value) #don't think we need this; actually we could use
    #in #populate but it caused errors so we didnt anyways
    @grid[pos[0]][pos[1]] = value
  end

end
