require 'gosu'
require_relative 'gol.rb'

class GOLWindow < Gosu::Window
  def initialize
    super 640, 480
    @height = 480
    @width = 640
    super width, height
    self.caption = "Game of Life"

    @background = Gosu::Color.new(0xffdedede)
    @alive_color = Gosu::Color.new(0xff121212)
    @dead_color = Gosu::Color.new(0xffededed)

    @rows = height / 10
    @columns = width / 10
    @row_pixels = height / @rows
    @column_pixels = width / @columns

    # create the world.
    @world = World.new(@rows, @columns)
    @game = Game.new(@world)
  end

  def update
    @game.tick!
  end

  def draw
    draw_background
    draw_cells
  end

  private
  def draw_cells
    @game.world.all_cells.each do |cell|
      draw_cell cell
    end
  end

  def draw_cell(cell)
    x_pos = cell.x * @column_pixels
    y_pos = cell.y * @row_pixels
    color = (cell.alive?) ? @alive_color : @dead_color
    draw_quad(x_pos, y_pos, color,
              x_pos + (@column_pixels - 1), y_pos, color,
              x_pos + (@column_pixels - 1), y_pos + (@row_pixels - 1), color,
              x_pos, y_pos + (@row_pixels - 1), color)
  end

  def draw_background
    draw_quad(0, 0, @background,
              width, 0, @background,
              width, height, @background,
              0, height, @background)
  end
end

window = GOLWindow.new
window.show
