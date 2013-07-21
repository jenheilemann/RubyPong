class Button < Text
  include Collisions
  attr_accessor :selected, :highlighting

  def initialize(x=0, y=0, text="Hello, World", size=48, alpha=150)
    @highlighting = false
    @pop = Rubygame::Sound.autoload "pop.wav"
    @selected = true

    super(x,y,text,size,alpha)
  end

  def handle_event(event)
    events = []
    case event
    when Rubygame::MouseMotionEvent
      if inside?(event.pos)
        @highlighting = true
      else
        @highlighting = false unless @selected
      end
    when Rubygame::MouseUpEvent
      if inside?(event.pos)
        pop
        events << Rubygame::ButtonClickEvent.new(text.downcase)
      else
        @selected = false
      end
    when Rubygame::KeyDownEvent
      case event.key
      when Rubygame::K_RETURN,
           Rubygame::K_LEFT,
           Rubygame::K_RIGHT
        pop
        events << Rubygame::ButtonClickEvent.new(text.downcase)
      end
    end
    events
  end

  def pop
    @pop.play if Game::CONFIGS[:sound_fx]
  end

  def highlight
    if @surface.alpha < 255
      @surface.alpha += 5
    end
  end

  def unhighlight
    if @surface.alpha > @alpha
      @surface.alpha -= 5
    end
  end

  def draw
    highlight   if     @highlighting
    unhighlight unless @highlighting

    super
  end
end