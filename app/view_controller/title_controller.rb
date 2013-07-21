class TitleController < ViewController
  def initialize(game)
    super(game)

    @title = Text.new(0, 95, "RubyPong", 100)
    @title.bold

    # add a pretty line under the title
    rect = Rubygame::Surface.new([@screen.width, 10]).fill([255,255,255])
    @line   = GameObject.new(0,@title.bottom + 15,rect)

    # menu items
    menu = [
      last = Button.new(0, @line.bottom+40,"Play Game", 50),
      last = Button.new(0, last.bottom+12, "Options",   50),
      last = Button.new(0, last.bottom+12, "About",     50),
             Button.new(0, last.bottom+12, "Quit",      50)
    ]
    # center everything horizontally
    [@title,@line,*menu].each(&:center_x)

    @selector = Selector.new(*menu)

    # Set up the objects for drawing
    @objects = [@title,@line,@selector]
  end

  def update(tick_event)
    @selector.update(tick_event)

    @queue.peek_each do |event|
      new_events = @selector.handle_event(event)
      unless new_events.nil? || new_events.empty?
        new_events.each { |ev| @queue.push ev }
        @queue.delete(event)
      end
    end

    # hand off to the ViewController for heavy lifting
    super(tick_event)
  end

end