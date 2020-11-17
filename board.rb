# frozen_string_literal: true

require 'pry'
# Creating an m-by-m board
class Board
  attr_accessor :size
  attr_reader :cells, :overwrite, :starting_cell_values
  def initialize(size, starting_cell_values = '  ', overwrite = false)
    self.size = size.to_i
    @starting_cell_values = starting_cell_values
    @overwrite = overwrite
    @cells = []
  end

  def call_make_grid
    make_cells
    display_grid(size)
  end

  # Using array[row/size][row%size] allows me to select a particular element
  def select_cell(row, col = nil)
    col.nil? ? cells[row / size][row % size] : cells[row][col]
  end

  def write_to_cell?(cell)
    if cell == starting_cell_values
      true
    elsif overwrite
      true
    else
      immutable_cell(cell) or false
    end
  end

  def call_update_cells(val, row, col = nil)
    cell = select_cell(row, col)
    write_to_cell?(cell) ?  update_cells(val, row, col) : immutable_cell(cell)
    display_grid(size)
  end

  private

  def immutable_cell(cell)
    puts "That cell contains #{cell} and cannot be changed! Choose an empty cell."
  end

  def make_cells
    (1..size).each { cells.push([starting_cell_values] * size) }
  end

  def update_cells(val, row, col)
    cells[row][col] = val unless col.nil?
    cells[row / cells.length][row % cells.length] = val
  end

  # Think of "x % n == 0" as identifying groups of n (normal division)
  # If you remember the caeser cipher, the same concept is behind % 26.
  # You can alternatively use << or <<- to make multi-line strings
  def display_grid(size)
    (1..size**2).each do |i|
      (i % size).zero? ? ((puts "| #{cells.flatten[i - 1]} |") or puts) : (print "| #{cells.flatten[i - 1]} ")
    end
  end
end
