class Switch < Button
  def initialize(x=0, y=0, size, prefix, key)
    @prefix = prefix
    @key = key
    super(x,y, generated_text, size)
  end

  def toggle
    Game::CONFIGS[@key] = !Game::CONFIGS[@key]
    self.text = generated_text
    Game::CONFIGS.save
  end

  def generated_text
    if Game::CONFIGS[@key]
      return "#{@prefix}: On"
    else
      return "#{@prefix}: Off"
    end
  end

  def handle_event(event)
    case event
    when Rubygame::MouseUpEvent
      if inside?(event.pos)
        toggle
      end
    when Rubygame::KeyDownEvent
      case event.key
      when Rubygame::K_RETURN,
           Rubygame::K_LEFT,
           Rubygame::K_RIGHT
        toggle
      end
    end

    super(event)
  end
end