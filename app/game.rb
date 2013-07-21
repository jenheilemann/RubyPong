class Game
  attr_accessor :screen, :queue, :clock, :state

  # Constants
  BACKGROUND_COLOR = [50,90,52]
  SCREEN = Screen.new(
    [940,680],              # screen size, WxH
    0,                      # color depth
    [                       # Flags being passed to Rubygame
      Rubygame::HWSURFACE,  # => accelerated display using teh
                            #     fancy graphics card, if it's available
      Rubygame::DOUBLEBUF   # => double buffering the output
    ]
  )
  CONFIGS = Configs.new(File.join(File.dirname(__FILE__),'..','config','game_settings.yml'))

  # setting up the 'initial' values for the game... go figure!
  def initialize
    @screen = SCREEN
    @screen.title = "RubyPong"

    @queue = Rubygame::EventQueue.new

    @clock = Rubygame::Clock.new
    @clock.target_framerate = 40
    @clock.enable_tick_events
    @clock.calibrate()

    @state = nil
    @state_buffer = nil
  end

  # starting the game up and setting up the loop that refreshes the @screen
  def run!
    loop do
      tick_event = @clock.tick
      update(tick_event)
      draw
    end
  end

  # run once every tick (or frame)
  def update(tick_event)
    @mod_keys ||= []

    @queue.peek_each do |event|
      case event
      when Rubygame::QuitEvent
        Rubygame.quit
        exit
      when Rubygame::KeyDownEvent
        @mod_keys << event.key
        case event.key
        when Rubygame::K_ESCAPE
          if @state.class == TitleController
            @queue.push Rubygame::QuitEvent.new
          else
            @state.handle_action("escape")
            @queue.delete(event)
          end
        when Rubygame::K_Q,
             Rubygame::K_LSUPER,
             Rubygame::K_RSUPER,
             Rubygame::K_LCMD,
             Rubygame::K_RCMD
          if Rubygame.is_super_and(Rubygame::K_Q,@mod_keys)
            @queue.push Rubygame::QuitEvent.new
          end
        end
      when Rubygame::KeyUpEvent
        @mod_keys.delete(event.key)
      end
    end

    @state.update(tick_event)
    unless @state_buffer.nil?
      @state = @state_buffer
      @state_buffer = nil
    end
  end

  def draw
    @state.draw
  end

  def switch_state(new_state)
    if @state.nil?
      @state = new_state
    else
      @state_buffer = new_state
    end
  end
end
