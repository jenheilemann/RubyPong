class PauseController < ViewController
  def initialize(game, old_state)
    super(game, old_state)

    @title = Text.new(0,0,"Paused",100)
    @title.center
    @subtext = Text.new(0,0,"Press SPACE to unpause",60,180)
    @subtext.center
    @subtext.y = @title.bottom + 20

    @objects = [@title,@subtext]
  end

  def update(tick_event)
    @queue.peek_each do |event|
      case event
      when Rubygame::KeyDownEvent
        case event.key
        when Rubygame::K_SPACE
          @queue.push Rubygame::ButtonClickEvent.new('play')
          @queue.delete(event)
        end
      end
    end

    super(tick_event)
  end

end