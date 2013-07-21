class WonController < ViewController

  def initialize(game,player,old_state)
    super(game, old_state)

    @win_text = Text.new(0,0,"#{player.name} Wins!", 60)
    @win_text.bold
    @win_text.center

    @play_again_text = Text.new(0, 0, "Play again? Y or N", 40)
    @play_again_text.center_x
    @play_again_text.y = @win_text.bottom + 20

    @objects = [@play_again_text,@win_text]
  end

  # run once every tick (or frame)
  def update(tick_event)
    @queue.peek_each do |event|
      case event
      when Rubygame::KeyDownEvent
        case event.key
        when Rubygame::K_Y
          @game.switch_state(PlayController.new(@game, @old_state.old_state))
        when Rubygame::K_N
          @game.switch_state( @old_state.old_state )
          @queue.delete(event)
        end
      end
    end

    super(tick_event)
  end

  def handle_action(action)
    if action.include?("escape")
      @game.switch_state( @old_state.old_state )
    else
      super(action)
    end
  end

end