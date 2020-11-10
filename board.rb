# frozen_string_literal: true

# Creating an m-by-m board
class Board
  attr_accessor :size
  attr_reader :cells
  def initialize(size)
    self.size = size.to_i
    @cells = []
  end

  def call_make_grid
    make_cells(@cells)
    make_grid(size)
  end

  private

  def make_cells(cells)
    (0...size**2).each do
      cells.push(' ')
    end
  end

  # Think of "x % n == 0" as identifying groups of n (normal division)
  # If you remember the caeser cipher, the same concept is behind % 26.
  # You can alternatively use << or <<- to make multi-line strings
  def make_grid(size)
    (1..size**2).each do |i|
      (i % 3).zero? ? (puts "| #{i} ") : (print "| #{i} ")
    end
  end
end

board = Board.new(3)
board.call_make_grid
puts
