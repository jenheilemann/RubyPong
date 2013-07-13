class Background < GameObject
  def initialize(w, h)
    surface = Rubygame::Surface.new [w,h]

    # draw the game board
    color = [255,255,255]

    # background color
    surface.fill([50,90,52])

    # Top
    surface.draw_box_s [0, 0], [surface.width, 10], color
    # Left
    surface.draw_box_s [0, 0], [10, surface.height], color
    # Bottom
    surface.draw_box_s [0, surface.h-10], [surface.w,surface.h], color
    # Right
    surface.draw_box_s [surface.w-10, 0], [surface.w,surface.h], color
    # Middle Divide
    surface.draw_box_s [surface.w/2-5, 0],[surface.w/2+5, surface.h], color

    # adding some lines to make it look more ping-pong-y
    surface.draw_line_a [0, 0],[surface.w, surface.h], color
    surface.draw_line_a [surface.w, 0],[0, surface.h], color


    super 0,0,surface
  end
end
