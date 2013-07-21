class Selector < GameObject
  attr_reader :buttons
  attr_writer :choice

  # constants
  SPEED = 500

  def initialize(*buttons)
    @buttons  = buttons
    @choice = 0
    @buttons.each { |b| b.selected = false }
    @buttons[@choice].highlighting = true
    @buttons[@choice].selected = true
    @old_choice = nil

    @x   = @buttons[@choice].left  - @buttons[@choice].width/2
    @r_x = @buttons[@choice].right + @buttons[@choice].width/2
    @y   = @buttons[@choice].top

    @size_multiplier = @buttons[@choice].height/10
    paddle_width  = @size_multiplier
    paddle_height = @buttons[@choice].height - @size_multiplier
    @left  = Rubygame::Surface.new([paddle_width,paddle_height])
    @left.fill([255,255,255])
    @right = Rubygame::Surface.new([paddle_width,paddle_height])
    @right.fill([255,255,255])

    super(@x,@y,@left)
  end

  def draw
    @left.blit(Game::SCREEN,  [@x,  @y])
    @right.blit(Game::SCREEN, [@r_x,@y])
    @buttons.each(&:draw)
  end

  def update(tick_event)
    x_target       = @buttons[@choice].left - 15
    right_x_target = @buttons[@choice].right + 15 - @right.width
    y_target       = @buttons[@choice].top + @size_multiplier

    speed = SPEED * tick_event.seconds
    @x   = move(@x,   x_target,       speed)
    @r_x = move(@r_x, right_x_target, speed)
    @y   = move(@y,   y_target,       speed)
  end

  def handle_event(event)
    new_events = []

    case event
    when Rubygame::MouseMotionEvent
      @buttons.each_with_index do |b, i|
        if b.inside?(event.pos)
          @choice = i
          @buttons.each { |b| b.selected = false }
          @buttons[@choice].selected = true
        end
        b.handle_event(event)
      end
    when Rubygame::MouseUpEvent
      new_events << @buttons[@choice].handle_event(event)
    when Rubygame::KeyDownEvent
      case event.key
      when Rubygame::K_UP
        prev_selection
      when Rubygame::K_DOWN
        next_selection
      when Rubygame::K_RETURN,
           Rubygame::K_LEFT,
           Rubygame::K_RIGHT
        new_events << @buttons[@choice].handle_event(event)
      end
    end
    return new_events.flatten.compact
  end

  def move(coord, target, speed)
    if coord != target && (coord - target).abs < speed
      coord = target
    elsif coord < target
      coord += speed + (target - coord)/10
    elsif coord > target
      coord -= speed + (coord - target)/10
    end
    coord
  end

  def prev_selection
    @old_choice = @buttons[@choice]
    if @choice == 0
      @choice = @buttons.count - 1
    else
      @choice -= 1
    end
    @old_choice.selected = false
    @old_choice.highlighting = false
    @buttons[@choice].selected = true
    @buttons[@choice].highlighting = true
  end

  def next_selection
    @old_choice = @buttons[@choice]
    if @choice == @buttons.count - 1
      @choice = 0
    else
      @choice += 1
    end
    @old_choice.selected = false
    @old_choice.highlighting = false
    @buttons[@choice].selected = true
    @buttons[@choice].highlighting = true
  end

  def choice
    @buttons[@choice]
  end

end