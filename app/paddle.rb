class Paddle < GameObject
  def initialize(x, y)
    surface = Rubygame::Surface.new([20,100])
    surface.fill([255,255,255])

    super x,y,surface
  end

  # Center the player vertically on the screen
  def center_y(screen_height)
    @y = screen_height/2 - @height/2
  end
end