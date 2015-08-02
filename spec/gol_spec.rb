require 'rspec'
require_relative '../gol.rb'

describe 'Game Of Life' do

  context 'World' do
    before(:each) do
      @world = World.new(5, 5)
    end

    it 'initializes correctly' do
      expect(@world.columns).to be(5)
      expect(@world.rows).to be(5)
      expect(@world.cell_grid).not_to be_empty
    end

    it 'returns all cells when asked' do
      expect(@world.all_cells.count).to be(25)
    end
  end

  context 'Cell' do
    before(:each) do
      @cell = Cell.new(1, 1)
    end

    it 'should be dead by default and respond to alive?' do
      expect(@cell).not_to be_alive
    end

    it 'dies when told' do
      @cell.alive = true
      @cell.die!

      expect(@cell.alive).to be(false)
    end

    it 'lives when told' do
      @cell.alive = false
      @cell.live!

      expect(@cell.alive).to be(true)
    end
  end

  context 'Game' do
    before(:each) do
      @world = World.new(5, 5)
      @game = Game.new(@world)
    end

    it 'initializes world' do
      expect(@game.world).not_to be_nil
    end

    it 'ticks correctly' do
      # set up some state.
      state = [
               [1, 0, 0, 0, 0],
               [0, 0, 1, 0, 0],
               [0, 1, 1, 1, 0],
               [1, 0, 1, 1, 1],
               [1, 1, 0, 1, 0],
              ]
      state.each_with_index do |rows, row|
        rows.each_with_index do |item, col|
          if item == 1
            @game.world.cell_grid[row][col].live!
          else
            @game.world.cell_grid[row][col].die!
          end
        end
      end

      @game.tick!

      # in this state i expect:
      # [0][0] to die
      expect(@world.cell_grid[0][0]).not_to be_alive
      # [2][2] to die
      expect(@world.cell_grid[2][2]).not_to be_alive
      # [4][0] to live
      expect(@world.cell_grid[4][0]).to be_alive
      # [4][4] to live
      expect(@world.cell_grid[4][4]).to be_alive
    end
  end
end
