require_relative "board.rb"
require 'colorize'

class MinesweeperGame
  def initialize(size,bombs)
    #solution uses a hash of hashes to store defaut small, med, large boards.
    @board = Board.new(size,bombs)
  end

  def run
    until @board.game_over?
      @board.render
      pos, move_type = prompt
      #solution moves rest of loop to new method.
      if move_type == :f
        @board[pos].flag
      elsif @board[pos].reveal(@board) == :boom
        puts "you lost the game."
      end
    end

    if @board.board_won?
      puts "You win!"
    end
    @board.render
    # until board.game_over?
    #   get flag or reveal and position
    #   flag position or reveal it
    #     if board.all (revealed or flagged && no false_flags
    #       win
  end

end

def save
  puts "put a filename:"
  filename = gets.chomp
  if filename[-4..-1] != ".txt"
    filename << ".txt"
  end
  File.write("./savegames/" + filename, self.to_yaml)
end

def prompt
  #asks user for a move_type and position(as 1 array with row,col)

  while true
    puts "type 'save' to save"
    puts "To reveal a square, enter a position as [row],[column]"
    puts "To flag/unflag a mine, enter f,[row],[column]"
    position_move = gets.chomp.split(",")
    #the code is clearer if the input is formatted differently, and
    #row/column not immediately joined.
    save if position_move.join("") == "save"
    if position_move.length == 2
      return position_move.map { |move| move.strip.to_i }, :r
    elsif position_move.length == 3
      return  position_move.drop(1).map { |move| move.strip.to_i }, :f
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV[0]
    YAML.load_file("./savegames/" + ARGV.shift).run
  end
  a = MinesweeperGame.new(9,10).run
end
