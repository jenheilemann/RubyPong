class LicenseController < ViewController

  def initialize(game, old_state)
    super(game, old_state)

    @title = Text.new(40, 65, "RubyPong Licensing Information", 60)
    @title.bold

    # add a pretty line under the title
    rect  = Rubygame::Surface.new([@screen.width, 10]).fill([255,255,255])
    @line = GameObject.new(0,@title.bottom + 15,rect)

    y = @line.bottom + 60

    texts = []
    texts << "Copyright (c) 2013, Sierra Bravo Corp., dba The Nerdery. All rights reserved."
    texts << " "
    texts << "Redistribution and use in source and binary forms, with or without modification, are permitted provided that the"
    texts << "following conditions are met:"
    texts << " "
    texts << "* Redistributions of source code must retain the above copyright notice, this list of conditions and the following"
    texts << "disclaimer."
    texts << "* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following"
    texts << "disclaimer in the documentation and/or other materials provided with the distribution."
    texts << " "
    texts << 'THIS SOFTWARE IS PROVIDED BY THE NERDERY AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,'
    texts << "INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR"
    texts << "PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE NERDERY OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,"
    texts << "INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF"
    texts << "SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND"
    texts << "ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR"
    texts << "OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY"
    texts << "OF SUCH DAMAGE."

    texts.collect! do |text|
      new_text = Text.new(40,y,text,17)
      y += new_text.font.line_skip
      new_text
    end

    # menu items
    @selector = Selector.new(
      last = Button.new(40, Game::SCREEN.bottom-40, "Back", 24),
    )

    @objects = [@title,@line,*texts,@selector]
  end

  def update(tick_event)
    @selector.update(tick_event)
    new_events = []

    @queue.peek_each do |event|
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