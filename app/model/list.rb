class List < Button
  def initialize(x,y,size,prefix,key,options)
    @prefix  = prefix
    @key     = key
    @options = options.to_a
    @current = @options.find_index(Game::CONFIGS[@key])
    super(x,y,generated_text,size)
  end

  def cycle(reverse = false)
    unless reverse
      @current += 1
      @current = 0 if @options[@current].nil?
    else
      @current -= 1
      @current = @options.count + 1 if @options[@current].nil?
    end
    Game::CONFIGS[@key] = @options[@current]
    self.text = generated_text
    Game::CONFIGS.save
  end

  def generated_text
    return "#{@prefix}: #{Game::CONFIGS[@key]}"
  end

  def handle_event(event)
    case event
    when Rubygame::MouseUpEvent
      if inside?(event.pos)
        cycle
      end
    when Rubygame::KeyDownEvent
      case event.key
      when Rubygame::K_RETURN,
           Rubygame::K_RIGHT
        cycle
      when Rubygame::K_LEFT
        cycle(true)
      end
    end

    super(event)
  end
end