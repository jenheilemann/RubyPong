class Text < GameObject
  attr_reader :text, :font, :alpha

  def initialize(x=0, y=0, text="Hello, World", size=48, alpha=255)
    font_location = File.join(
      File.dirname(__FILE__),'..','assets','fonts','museo-slab.ttf')
    @font = Rubygame::TTF.new(font_location, size)
    @text = text
    @color = [255,255,255]
    @alpha = alpha
    @size = size
    super(x,y,rerender_text())
  end

  def rerender_text
    @width, @height = @font.size_text(@text)
    @surface = @font.render(@text, true, @color, Game::BACKGROUND_COLOR)
    @surface.alpha = @alpha
    @surface
  end

  def text=(string)
    @text = string
    rerender_text
  end

  def bold(on = true)
    if on
      font_location = File.join(
        File.dirname(__FILE__),'..','assets','fonts','museo-slab-bold.ttf')
      @font = Rubygame::TTF.new(font_location, @size)
      rerender_text
    else
      font_location = File.join(
        File.dirname(__FILE__),'..','assets','fonts','museo-slab.ttf')
      @font = Rubygame::TTF.new(font_location, @size)
      rerender_text
    end
  end
end