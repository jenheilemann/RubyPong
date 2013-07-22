class OptionsController < ViewController

  def initialize(game, old_state)
    super(game, old_state)

    @title = Text.new(40, 65, "RubyPong Options", 60)
    @title.bold

    # add a pretty line under the title
    rect  = Rubygame::Surface.new([@screen.width, 10]).fill([255,255,255])
    @line = GameObject.new(0,@title.bottom + 15,rect)

    # menu items
    @selector = Selector.new(
           Button.new(40,@screen.bottom-40,  "Back", 36),
      last=Switch.new(40,@line.bottom+60,30, "Music", :music),
      last=Switch.new(40,last.bottom+12, 30, "Sound Effects", :sound_fx),
      last=List.new(  40,last.bottom+12, 30, "Winning Score", :winning_score, [-1,1,3,5,7]),
      last=List.new(  40,last.bottom+12, 30, "Game Speed",  :game_speed,  Array(1..10)),
           Button.new(40,last.bottom+36,     "Reset Options", 30)
    )

    @objects = [@title,@line,@selector]

  end

  def update(tick_event)
    @selector.update(tick_event)

    @queue.peek_each do |event|
      new_events = []
      @objects.each do |obj|
        new_events << obj.handle_event(event)
      end
      new_events = new_events.flatten.compact

      unless new_events.nil? || new_events.empty?
        new_events.each { |ev| @queue.push ev }
        @queue.delete(event)
      end
    end

    # hand off to the ViewController for heavy lifting
    super(tick_event)
  end

end