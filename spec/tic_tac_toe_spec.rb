# frozen-string-literal: true

require_relative '../tic_tac_toe.rb'
require_relative '../players.rb'
require_relative '../board.rb'

describe TicTacToe do
  # let(:player_one) { instance_double(Player, name: 'Foo') }
  # let(:player_two) { instance_double(Player, name: 'Bar') }
  # let(:board) { instance_double Board }
  
  # No need to test:
  # initialize --> sets instance variables, calls one function
  # announce_winner --> just outputs
  # row_winner --> script method calling find_match
  # check_winner --> script method
  # valid_cell --> script method
  # player_input --> just a puts and a gets
  
  describe '#name_players' do
    subject(:tic_tac_toe_name) { described_class.new }
    before do
      allow(tic_tac_toe_name.board).to receive(:call_update_cells)
      allow(tic_tac_toe_name).to receive(:puts)
      allow(tic_tac_toe_name).to receive(:gets).and_return('Foo', 'Bar')
    end

    context 'when called' do
      it 'ends after naming two players' do
        expect(tic_tac_toe_name).to receive(:gets).twice
        tic_tac_toe_name.name_players
      end
    end
  end

  describe '#noughts_and_crosses' do
    subject(:tic_tac_toe_XO) { described_class.new }
    before do
      allow(tic_tac_toe_XO.board).to receive(:call_update_cells)
      allow(tic_tac_toe_XO).to receive(:check_winner)
      allow(tic_tac_toe_XO).to receive(:player_input).and_return(3)
      tic_tac_toe_XO.instance_variable_set(:@players, { 'Foo' => 'X', 'Bar' => 'O' })
    end
    context 'when no one has won' do
      before do
        tic_tac_toe_XO.instance_variable_set(:@winner, false)
        tic_tac_toe_XO.instance_variable_set(:@players, { 'Foo' => 'X', 'Bar' => 'O' })
      end

      context 'if the input is invalid then valid' do
        before { allow(tic_tac_toe_XO).to receive(:continue?).and_return(false, true) }
        it 'requests input three times, once for the next player' do
          expect(tic_tac_toe_XO).to receive(:player_input).exactly(3).times
          expect(tic_tac_toe_XO).to receive(:check_winner).twice
          tic_tac_toe_XO.noughts_and_crosses
        end
      end

      context 'if the input is valid the frist time' do
        before { allow(tic_tac_toe_XO).to receive(:continue?).and_return true }

        it 'loops twice, once for each player' do
          expect(tic_tac_toe_XO).to receive(:player_input).twice
          expect(tic_tac_toe_XO).to receive(:check_winner).twice
          tic_tac_toe_XO.noughts_and_crosses
        end
      end
    end

    context 'when someone has won' do
      before do
        tic_tac_toe_XO.instance_variable_set(:@winner, true)
        allow(tic_tac_toe_XO).to receive(:continue?).and_return true
      end
      context 'if the input is valid' do
        it 'loops once' do
          expect(tic_tac_toe_XO).to receive(:check_winner).once
          tic_tac_toe_XO.noughts_and_crosses
        end
      end
    end
  end

  describe '#find_match' do
    subject(:tic_tac_toe_match) { described_class.new }
    let(:foo) { instance_double(Player, name: 'Foo') }
    let(:bar) { instance_double(Player, name: 'Bar') }
    before do
      tic_tac_toe_match.instance_variable_set(:@players, { foo => 'X', bar => 'O' })
    end

    context 'when all the symbols in a row match' do
      it 'sets @winner to \'Foo\' when the symbols are Xs' do
        row = %w[X X X]
        tic_tac_toe_match.find_match(row)
        winner = tic_tac_toe_match.instance_variable_get(:@winner)
        expect(winner.name).to eq('Foo')
      end

      it 'sets @winner to \'Bar\' when the symbols are Os' do
        row = %w[O O O]
        tic_tac_toe_match.find_match(row)
        winner = tic_tac_toe_match.instance_variable_get(:@winner)
        expect(winner.name).to eq('Bar')
      end
    end

    context 'when not all symbols are matching' do
      it 'keeps @winner as false' do
        row = %w[X O X]
        tic_tac_toe_match.find_match(row)
        winner = tic_tac_toe_match.instance_variable_get(:@winner)
        expect(winner).to be false
      end

    end
  end

  describe '#diagonal' do
    subject(:tic_tac_toe_diag) { described_class.new }

    context 'when given a matrix' do
      it 'returns the values along the main diagonal' do
        matrix = [%w[1 X X], %w[X 1 X], %w[X X 1]]
        main_diagonal = tic_tac_toe_diag.diagonal(matrix)
        expect(main_diagonal).to eq(%w[1 1 1])
      end
    end
  end

  # Maybe a controller would have been better?
  describe '#diagonal_winner' do
    subject(:tic_tac_toe_diag_winner) { described_class.new }
    context 'when a match is not in the main diagonal' do
      before do
        allow(tic_tac_toe_diag_winner).to receive(:diagonal)
        allow(tic_tac_toe_diag_winner.instance_variable_get(:@cells)).to receive(:map)
      end
      it 'calls find_match twice' do
        expect(tic_tac_toe_diag_winner).to receive(:find_match).twice
        tic_tac_toe_diag_winner.diagonal_winner
      end
    end
  end

  describe '#player_symbol' do
    subject(:tic_tac_toe_symbol) { described_class.new }
    context 'before a move can be made' do
      before { tic_tac_toe_symbol.instance_variable_set(:@players, { 'Foo' => '', 'Bar' => '' }) }
      it 'gives each player a symbol' do
        players = tic_tac_toe_symbol.instance_variable_get(:@players)
        tic_tac_toe_symbol.player_symbol
        expect(players.values).to contain_exactly('X', 'O')
      end
    end
  end

  describe '#continue?' do
    subject(:tic_tac_toe_continue) { described_class.new }
    before { allow(tic_tac_toe_continue).to receive(:valid_cell?) }
    context 'when given the wrong intput' do
      it 'does not call #valid_cell?' do
        wrong_value = 0
        expect(tic_tac_toe_continue).not_to receive(:valid_cell?)
        tic_tac_toe_continue.continue?(wrong_value)
      end
    end

    context 'when given the correct input' do
      it 'calls #valid_cell?' do
        right_value = 5
        expect(tic_tac_toe_continue).to receive(:valid_cell?)
        tic_tac_toe_continue.continue?(right_value)
      end
    end
  end
end
