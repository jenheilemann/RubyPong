class AboutController < ViewController

  def initialize(game, old_state)
    super(game, old_state)

    @title = Text.new(40, 65, "About RubyPong", 60)
    @title.bold

    # add a pretty line under the title
    rect  = Rubygame::Surface.new([@screen.width, 10]).fill([255,255,255])
    @line = GameObject.new(0,@title.bottom + 15,rect)

    y = @line.bottom + 60

    texts = []
    texts << "A pong clone, created by Jen Heilemann. Built with"
    texts << "love with the Making Games with Ruby Tutorial, by"
    texts << "Man With Code:"

    texts.collect! do |text|
      new_text = Text.new(40,y,text,40)
      y += new_text.font.line_skip
      new_text
    end

    @site = Button.new(0,y+45,"http://manwithcode.com/",50)
    @site.font.underline=true
    @site.rerender_text
    @site.center_x

    # menu items
    @selector = Selector.new(
      last = Button.new(40, Game::SCREEN.bottom-40, "Back", 24),
             Button.new(last.right+30, Game::SCREEN.bottom-40, "License", 24)
    )

    @objects = [@title,@line,*texts,@site,@selector]
  end

  def update(tick_event)
    @selector.update(tick_event)
    new_events = []


    @queue.peek_each do |event|
      case event
      when Rubygame::MouseUpEvent,
        Rubygame::MouseMotionEvent
        new_events << @site.handle_event(event)
      end
      new_events << @selector.handle_event(event)
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