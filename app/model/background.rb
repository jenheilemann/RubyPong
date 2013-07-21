class Background < GameObject
  def initialize
    w = Game::SCREEN.width
    h = Game::SCREEN.height
    surface = Rubygame::Surface.new [w,h]

    # draw the game board
    color = [255,255,255]

    # background color
    surface.fill(Game::BACKGROUND_COLOR)

    # white screen borders
    # top \ left \ bottom \ right
    surface.draw_box_s [0, 0], [surface.width, 10], color
    surface.draw_box_s [0, 0], [10, surface.height], color
    surface.draw_box_s [0, surface.h-10], [surface.w,surface.h], color
    surface.draw_box_s [surface.w-10, 0], [surface.w,surface.h], color
    # Middle Divide
    surface.draw_box_s [surface.w/2-5, 0],[surface.w/2+5, surface.h], color

    # adding some lines to make it look more ping-pong-y
    surface.draw_line_a [10, 10],[surface.w-10, surface.h-10], color
    surface.draw_line_a [surface.w-10, 10],[10, surface.h-10], color

    super 0,0,surface
  end
end
