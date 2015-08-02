class Game
  attr_accessor :world

  def initialize(world)
    @world = world
    seed_randomly
  end

  def tick!
    # This is where the rules should be calculated, each tick
    cells_to_kill = []
    cells_to_live = []

    # get the alive neighbors of the each cell
    @world.all_cells.each do |cell|
      alive_around_cell = @world.alive_neighbors(cell).count

      # RULE 1
      # Any live cell with fewer than 2 live neighbors die.
      if cell.alive? and alive_around_cell < 2
        cells_to_kill << cell
      end

      # RULE 2
      # Any live cell with 2 or 3 neighbors live.
      if cell.alive? and (alive_around_cell == 2 or alive_around_cell == 3)
        cells_to_live << cell
      end

      # RULE 3
      # Any live cell with greater than 3 neighbors die.
      if cell.alive? and alive_around_cell > 3
        cells_to_kill << cell
      end

      # RULE 4
      # Any dead cell with exactly 3 neighbors comes to life.
      if !cell.alive? and alive_around_cell == 3
        cells_to_live << cell
      end
    end

    cells_to_live.each do |cell|
      cell.live!
    end
    cells_to_kill.each do |cell|
      cell.die!
    end
  end

  private

  def seed_randomly
    @world.all_cells.each do |cell|
      cell.alive = true if rand(1..100) > 80
    end
  end
end

class World
  attr_accessor :cell_grid, :rows, :columns

  def initialize(rows, columns)
    @rows = rows
    @columns = columns

    @cell_grid = Array.new(rows) do |row|
      Array.new(columns) do |column|
        Cell.new(column, row)
      end
    end
  end

  def all_cells
    cells = []
    @cell_grid.each do |row|
      row.each do |cell|
        cells << cell
      end
    end
    cells
  end

  def alive_neighbors(cell)
    # Must hit all directions around cell
    # |_|_|_|
    # |_|x|_|
    # |_|_|_|
    candidates = []
    candidates << @cell_grid[cell.y + 1][cell.x] if cell.y < (@rows - 1)
    candidates << @cell_grid[cell.y][cell.x + 1] if cell.x < (@columns - 1)
    candidates << @cell_grid[cell.y + 1][cell.x + 1] if
      cell.x < @columns - 1 && cell.y < @rows - 1
    candidates << @cell_grid[cell.y][cell.x - 1] if cell.x > 0
    candidates << @cell_grid[cell.y + 1][cell.x - 1] if
      cell.x > 0 && cell.y < @rows - 1
    candidates << @cell_grid[cell.y - 1][cell.x - 1] if
      cell.x > 0 && cell.y > 0
    candidates << @cell_grid[cell.y - 1][cell.x] if cell.y > 0
    candidates << @cell_grid[cell.y - 1][cell.x + 1] if
      cell.y > 0 && cell.x < @columns - 1

    alive = []
    candidates.each do |candidate|
      if (!candidate.nil?) && candidate.alive?
        alive << candidate
      end
    end
    alive
  end

end

class Cell
  attr_accessor :alive
  attr_reader :x, :y

  def initialize(x=0, y=0)
    @x = x
    @y = y
    @alive = false
  end

  def alive?
    @alive
  end

  def die!
    @alive = false
  end

  def live!
    @alive = true
  end
end
