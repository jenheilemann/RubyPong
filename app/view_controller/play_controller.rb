class PlayController < ViewController

  def initialize(game, old_state)
    super(game, old_state)

    init_objects

    @objects = [
      @background,
      @player1,
      @player2,
      @ball
    ]
  end

  def init_objects
    @background = Background.new
    @ball = Ball.new

    # Setting up the player to the left
    @player1 = Paddle.new(
      [50,10],          # [x,y]
      Rubygame::K_W,    # up key
      Rubygame::K_S,    # down key
      @screen,          # screen
      "Player 1"        # name
    )
    @player1.center_y

    # Setting up the player to the right
    x_start = @screen.width-@player1.width-50
    @player2 = Paddle.new(
      [x_start,10],     # [x,y]
      Rubygame::K_UP,   # up key
      Rubygame::K_DOWN, # down key
      @screen,          # screen
      "Player 2"        # name
    )
    @player2.center_y

    @player1.enemy = @player2
    @player2.enemy = @player1
  end

  # run once every tick (or frame)
  # this handles breaking the loop to allow the user to close the window
  def update(tick_event)
    new_events = []
    new_events << @player1.update(tick_event)
    new_events << @player2.update(tick_event)
    new_events << @ball.update(tick_event, @screen, [@player1, @player2])
    @queue.push(new_events.flatten)

    @queue.each do |event|
      @player1.handle_event(event, @queue)
      @player2.handle_event(event, @queue)
      @ball.handle_event(event)

      case event
      when Rubygame::KeyDownEvent
        case event.key
        when Rubygame::K_SPACE
          @game.switch_state(PauseController.new(@game, self))
        end
      when Rubygame::ScoreEvent
        if event.player.score == Game::CONFIGS[:winning_score]
          @game.switch_state(WonController.new(@game, event.player, self))
        end
      end
    end
  end

end