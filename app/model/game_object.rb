# GameObject
#
# Parent to objects that appear in the view, including backgrounds, text,
# players, balls... anything that has height & width, and needs to be
# placed on the screen.
class GameObject
  include Sides

  attr_accessor :x, :y, :width, :height, :surface

  def initialize(x,y,surface)
    @x       = x
    @y       = y
    @surface = surface
    @width   = surface.width
    @height  = surface.height
  end

  def draw
    @surface.blit(Game::SCREEN, [@x,@y])
  end

  # Center the object vertically on the screen
  def center_y
    @y = Game::SCREEN.height/2 - @height/2
  end

  # Center the object horizontally on the screen
  def center_x
    @x = Game::SCREEN.width/2 - @width/2
  end

  def center
    center_x
    center_y
  end

  # overloaded in child classes
  def update; end
  def handle_event(event); end
end