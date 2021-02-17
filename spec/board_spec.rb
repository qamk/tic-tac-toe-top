# frozen-string-literal: true

require_relative '../board.rb'

describe Board do
  # No need to test:
    # Initialize --> only sets instance variables
    # Call make grid --> public script method

  describe '#make_cells' do


    context 'when the size 3' do

      subject(:board_three) { described_class.new(3) }

      before do
        allow(board_three).to receive(:display_grid)
      end

      it 'makes a grid/array with 3 rows' do
        cells = board_three.instance_variable_get(:@cells)
        board_three.call_make_grid
        expect(cells.size).to eq 3
      end

      it 'makes a grid/array of 9 elements' do
        cells = board_three.instance_variable_get(:@cells)
        board_three.call_make_grid
        expect(cells.flatten.size).to eq 9
      end
    end

    context 'when the size is -3' do
      subject(:board_minus_three) { described_class.new(-3) }

      before { allow(board_minus_three).to receive(:display_grid) }

      it 'does not create a grid' do
        cells = board_minus_three.instance_variable_get(:@cells)
        board_minus_three.call_make_grid
        expect(cells).to be_empty
      end
    end
  end

  describe '#select_cell' do
    subject(:board_three) { described_class.new(3) }

    before do
      matrix = [%w[1 2 3], %w[4 5 6], %w[7 8 9]]
      board_three.instance_variable_set(:@cells, matrix)
    end

    context 'when size is 3, row is 7 and col is nil' do
      it 'selects the cell (2, 1)' do
        row = 7
        result = board_three.select_cell(row)
        expect(result).to eq '8'
      end
    end

    context 'when size is 3, row is 2 and col is 2' do
      it 'selects the cell (2, 2)' do
        row = 2
        col = 2
        result = board_three.select_cell(row, col)
        expect(result).to eq '9'
      end
    end

    context 'when size is 3 and row is negative' do
      it 'returns false' do
        row = -2
        row_result = board_three.select_cell(row)
        expect(row_result).to be false
      end
    end
  end

  describe '#write_to_cell?' do

    subject(:board_write) { described_class.new(3) }

    context 'when checking if a cell can be written to' do
      it 'returns true if the cell is empty' do
        empty_cell = '  '
        result = board_write.write_to_cell?(empty_cell)
        expect(result).to be true
      end

      it 'returns false if the cell is not empty' do
        filled_cell = '3'
        result = board_write.write_to_cell?(filled_cell)
        expect(result).to be false
      end
    end
  end

  describe '#call_update_cells' do

    subject(:board_update) { described_class.new(3) }

    before do
      allow(board_update).to receive(:select_cell)
      allow(board_update).to receive(:display_grid)
    end
    context 'when the cell exists and is empty' do
      before { allow(board_update).to receive(:write_to_cell?).and_return(true) }
      it 'calls #update_cells' do
        expect(board_update).to receive(:update_cells)
        board_update.call_update_cells('0', 0)
      end
    end

    context 'when the cell exists but is not empty' do
      before { allow(board_update).to receive(:write_to_cell?).and_return(false) }
      it 'calls #immutable_cell' do
        expect(board_update).to receive(:immutable_cell)
        board_update.call_update_cells('0', 0)
      end
    end

    context 'when the cell does not exist' do
      # Attempting spying
      let(:invalid_cell) { nil } # a non-existent array element
      before do
        allow(board_update).to receive(:write_to_cell?).and_return(false)
        allow(board_update).to receive(:immutable_cell).with(invalid_cell)
      end
      it 'calls #immutable_cell with nil' do
        board_update.call_update_cells('0', 0)
        expect(board_update).to have_received(:immutable_cell).with(invalid_cell)
      end
    end
  end

  describe '#update_cells' do
    subject(:board_update) { described_class.new(3) }
    before do
      matrix = [%w[1 2 3], %w[4 5 6], %w[7 8 9]]
      board_update.instance_variable_set(:@cells, matrix)
      allow(board_update).to receive(:select_cell)
      allow(board_update).to receive(:display_grid)
      allow(board_update).to receive(:write_to_cell?).and_return(true)
    end
    context 'when the cell is empty' do
      it 'updates the selected cell with a given value' do
        cell_to_update = 4
        update_value = '100'
        board_update.call_update_cells(update_value, cell_to_update)
        expect(board_update.instance_variable_get(:@cells).flatten).to include('100')
      end
    end
  end
end
