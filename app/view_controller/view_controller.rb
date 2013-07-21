# the ViewController class sets up all the possible different
# screen states. Given the game object and possibly an old state
# to revert to, the initializer will set up instance variables
# for the game, screen, and old state.
#
# Child classes should have an initializer that first calls
# `super(game)`, then sets up whatever instance variable game
# objects it needs, then adds those instance variables to the
# @objects array.
#
# Example:
#
# class SomeController < ViewController
#
#   def initialize(game, old_state)
#     super(game)
#
#     @some_object  = /whatevs/
#     @other_object = /whatevs/
#     @not_for_drawing = /whatevs/
#
#     @objects = [@some_object,@other_object]
#   end
#
#   def update(tick_event)
#
#     # let objects react to what's happening & add events to the queue
#     new_events << @some_object.update(tick_event, [])
#     @queue.push(new_events.flatten)
#
#     # handle things in the @queue
#     @queue.peek_each do |ev|
#       case ev
#       when Rubygame::KeyDownEvent
#         case ev.key
#         when Rubygame::K_SPACE
#           @game.switch_state( OtherController.new(@game) )
#         when Rubygame::K_N
#           @game.switch_state( @old_state )
#         end
#       end
#     end
#   end
#
# end
class ViewController
  attr_reader :old_state

  # Constants
  MUSIC = Rubygame::Music.autoload("music.wav")

  # param Game           the main Game instance
  # param ViewController (default: nil) the previous view so we can
  #                         unwind states/views
  def initialize(game, old_state=nil)
    @game = game
    @screen = game.screen
    @queue = game.queue
    @old_state = old_state
    @objects = []

    if !MUSIC.playing? && !MUSIC.fading? && Game::CONFIGS[:music]
      # volume can be between 0.0 (silent) and 1.0 (full volume)
      MUSIC.volume=(0.5)
      # fade in the music over n seconds, repeat m times (-1 for infinite)
      MUSIC.play({fade_in: 3, repeats: -1})
    end
  end

  # Writes the various objects to the screen
  def draw
    @screen.fill(Game::BACKGROUND_COLOR)
    @objects.each(&:draw)
    @screen.flip
  end

  # overloaded in child classes
  def update(tick_event)
    @queue.each do |event|
      case event
      when Rubygame::ButtonClickEvent
        handle_action(event.action)
      end
    end
  end

  def handle_action(action)
    puts "action: #{action}"
    case

    # URLS
    when action.start_with?("http://") && action.end_with?("/")
      `open #{action}`

    # turning on and off the music
    when action.include?("music")
      if Game::CONFIGS[:music] && !MUSIC.playing? && !MUSIC.fading?
        MUSIC.play({fade_in: 2, repeats: -1})
      else
        MUSIC.stop
      end

    # Play Controller
    when action.include?("play")
      if @old_state.class == PlayController
        @game.switch_state( @old_state )
      else
        @game.switch_state( PlayController.new(@game, self) )
      end

    # About page
    when action.include?("about")
      @game.switch_state( AboutController.new(@game, self) )

    # Resetting the options
    when action.include?("reset")
      Game::CONFIGS.reset
      @game.switch_state( OptionsController.new(@game, @old_state) )

    # Options page
    when action.include?("option") && self.class != OptionsController,
         action.include?("setting")
      @game.switch_state( OptionsController.new(@game, self) )

    # Return to previous screen
    when action.include?("exit")   && @old_state,
         action.include?("quit")   && @old_state,
         action.include?("back")   && @old_state,
         action.include?("escape") && @old_state
      @game.switch_state( @old_state )

    # Start a new menu
    when action.include?("menu")
      if @old_state.class == TitleController
        @game.switch_state( @old_state )
      else
        @game.switch_state( TitleController.new(@game) )
      end

    # Exit the game
    when action.include?("quit"),
         action.include?("exit"),
         action.include?("escape")
      MUSIC.stop if MUSIC.playing?
      Rubygame.quit
      exit
    end
  end

end