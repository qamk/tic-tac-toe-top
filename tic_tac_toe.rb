# frozen_string_literal: true

require 'pry'
# Import board and players classes
require_relative 'board.rb'
require_relative 'players.rb'
# Simple Tic Tac Toe game using a board and players
class TicTacToe
  attr_reader :players, :board, :cells, :winner
  def initialize(board = Board.new(3))
    @board = board
    @players = {}
    @winner = false
  end

  def announce_winner
    puts "We have a winner! Congrats #{winner.name}"
  end

  def make_grid
    @cells = board.cells
    board.call_make_grid
  end

  def play
    player_symbol
    loop do
      break if winner

      noughts_and_crosses
      cells.flatten.none?('  ') ? (puts 'Draw..........' or break) : nil
    end
  end

  def find_match(row)
    players.each do |player, mark|
      match = row.all?(mark) ? true : next
      @winner = match ? player : false
    end
  end

  def row_winner(ref_cells)
    ref_cells.each { |row| find_match(row) }
  end

  def diagonal(matrix)
    matrix = (0..2).map { |i| matrix[i][i] }
  end

  def diagonal_winner
    find_match(diagonal(cells))
    unless winner
      matrix = cells.map(&:reverse)
      find_match(diagonal(matrix))
    end
  end

  # Just wanted to try something, might use them to find matches in matrices or something similar (after changes)
  def check_winner
    cells_t = cells.transpose
    row_winner(cells)
    row_winner(cells_t)
    diagonal_winner unless winner
    announce_winner if winner
    winner
  end

  def player_symbol
    mark = %w[X O]
    players.each do |player, mrk|
      mrk += mark.sample
      players[player] = mrk
      mark.delete(mrk)
    end
  end

  def valid_cell?(value)
    cell = board.select_cell(value - 1)
    board.write_to_cell?(cell) ? true : false
  end

  def continue?(value)
    value < 1 || value > 9 ? ((puts 'Number between 1 and 9 please') or return(true)) : false
    valid_cell?(value)
  end

  def player_input(player, symbol)
    puts "#{player.name.capitalize} where would you like to put #{symbol}"
    gets.chomp.to_i
  end

  def noughts_and_crosses
    players.each do |player, symbol|
      value = -1
      loop do
        value = player_input(player, symbol)
        break if continue?(value)
      end
      board.call_update_cells(players[player], value - 1)
      check_winner
      break if winner
    end
  end

  def name_players
    i = 1
    loop do
      puts "What is the name for player #{i}"
      name = gets.chomp
      @players[Player.new(name)] = ''
      i += 1
      break if @players.length == 2
    end
  end
end
