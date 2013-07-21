class Paddle < GameObject
  attr_accessor :enemy, :name, :score

  SPEED = Game::CONFIGS[:paddle_speed] * 50

  def initialize( pos=[0,0], up_key=false, down_key=false, screen, name)
    x,y = pos

    surface = Rubygame::Surface.new([20,100])
    surface.fill([255,255,255])
    @moving_up = false
    @moving_down = false
    @up_key = up_key
    @down_key = down_key

    @top_limit = screen.top
    @bottom_limit = screen.bottom

    @name = name

    @score = 0
    @score_text = Text.new(
      0,                # x position
      screen.top + 15,  # y position
      @score.to_s,      # text content
      80,               # font size
      150,              # alpha
    )
    # is this paddle closer to the left or right? 1 is left, 3 is right
    score_side = ((x-screen.right).abs > (x-screen.left).abs) ? 1 : 3
    @score_text.x = (screen.width/4 * score_side) - @score_text.width/2

    super x,y,surface
  end

  def handle_event(event, queue)
    case event
    # capture keypresses
    when Rubygame::KeyDownEvent, Rubygame::KeyUpEvent
      move_or_stop(event.key)
    when Rubygame::BallScored
      add_score(event.wall_passed)
      queue.push(Rubygame::ScoreEvent.new(self))
    end
  end

  def move_or_stop(key)
    case key
    when @up_key
      @moving_up = !@moving_up
    when @down_key
      @moving_down = !@moving_down
    end
  end

  def add_score(wall)
    unless @enemy.nil?
      distance_to_wall       = (left - wall).abs
      enemy_distance_to_wall = (@enemy.left - wall).abs

      if distance_to_wall > enemy_distance_to_wall
        @score += 1
        @score_text.text = @score.to_s
      end
    end
  end

  def update(tick_event)
    if @moving_up && @y > @top_limit
      @y -= SPEED * tick_event.seconds
    end
    if @moving_down && @y+@height < @bottom_limit
      @y += SPEED * tick_event.seconds
    end
  end

  def draw
    super
    @score_text.draw
  end

end