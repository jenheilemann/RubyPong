class Ball < GameObject
  include Collisions

  SPEED = Game::CONFIGS[:ball_speed] * 50

  def initialize
    # get the image of the ball; Surface sets height/width based on the image
    surface = Rubygame::Surface.autoload "ball.png"

    # hit sound
    @pop = Rubygame::Sound.autoload "pop.wav"

    # set up start point
    x = Game::SCREEN.width/2 - surface.width/2
    y = Game::SCREEN.height/2 - surface.height/2

    # set up velocities, random directions
    @vx = SPEED * ([-1, 1].sample)
    @vy = SPEED * ([-1, 1].sample)

    # set up spin
    @spin = 1

    super(x,y,surface)
  end

  def update(tick_event, screen, paddles = [])
    @x += @vx * tick_event.seconds
    @y += @vy * tick_event.seconds

    paddles.each do |paddle|
      bounce_off(paddle)
    end

    wall_passed = bounce_off_walls(screen)
    return Rubygame::BallScored.new(wall_passed,screen) if wall_passed
  end

  def handle_event(event)
    case event
    when Rubygame::BallScored
      reset(event.screen)
    end
  end

  def reset(screen)
    # switch the horizontal direction of the ball
    @vx = -@vx

    # move the ball to somewhere in the middle two-fourths of the screen
    @x = screen.width/4 + rand(screen.width/2)

    # spawn nearly anywhere on the y-axis (except within 50 px of the edge)
    @y = rand(screen.height - 100) + 50
  end

  def bounce_off(obj)
    if collision?(obj)
      direction = get_collision_direction(obj)
      add_spin(obj)
      change(direction)
    end
  end

  def bounce_off_walls(screen)
    # bouncing off top or bottom
    if top <= screen.top || bottom >= screen.bottom
      change(:vertical)
    end

    # left or right is not a bounce
    if left <= screen.left
      return screen.left
    elsif right >= screen.right
      return screen.right
    end

    false
  end

  def change(direction)
    @pop.play if Game::CONFIGS[:sound_fx]
    if direction == :horizontal
      @vx = -@vx
    end
    if direction == :vertical
      @vy = -@vy
    end
  end

  def get_collision_direction(obj)

    case
    # velocity is south-eastern
    # bottom and right
    when @vy > 0 && @vx > 0
      horizontal_edge = right - obj.left
      vertical_edge = bottom - obj.top

    # velocity is south-western
    when @vy > 0 && @vx < 0
      horizontal_edge = left - obj.right
      vertical_edge = bottom - obj.top

    # velocity is north-eastern
    when @vy < 0 && @vx > 0
      horizontal_edge = right - obj.left
      vertical_edge = top - obj.bottom

    # velocity is north-western
    when @vy < 0 && @vx < 0
      horizontal_edge = left - obj.right
      vertical_edge = top - obj.bottom
    end

    return ( vertical_edge.abs >= horizontal_edge.abs ) ? :horizontal : :vertical
  end

  def add_spin(obj)
    obj_midpoint = obj.y + obj.height/2
    ball_midpoint = @y + @height/2

    percent_from_center = (ball_midpoint-obj_midpoint)/obj.height.to_f

    @spin = 1
  end
end