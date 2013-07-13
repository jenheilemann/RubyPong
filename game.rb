# setting up gems
require 'rubygems'
require 'rubygame'

# Getting the autoloader and loading our folders
require File.dirname(__FILE__) + '/lib/autoload'
autoload = Autoload.new(__FILE__)
autoload.require_all('lib')
autoload.require_all('app')

class Game

  # setting up the 'initial' values for the game... go figure!
  def initialize
    @screen = Rubygame::Screen.new [940,680], # screen size, WxH
      0,                                      # color depth
      [                                       # Flags being passed to Rubygame
        Rubygame::HWSURFACE,                  #   accelerated display using teh
                                              #     fancy graphics card, if it's
                                              #     available
        Rubygame::DOUBLEBUF                   # double buffering the output
      ]
    @screen.title = "Pong Fake"
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 40
    @background = Background.new(@screen.width,@screen.height)
    @player = Paddle.new(50,10)
    @player.center_y(@screen.height)
    @enemy = Paddle.new(@screen.width-@player.width-50,10)
    @enemy.center_y(@screen.height)
  end

  # starting the game up and setting up the loop that refreshes the @screen
  def run!
    loop do
      update
      draw
      @clock.tick
    end
  end

  # run once every tick (or frame)
  # this handles breaking the loop to allow the user to close the window
  def update
    @queue.each do |event|
      case event
      when Rubygame::QuitEvent
        exit
      end
    end
  end

  def draw
    @screen.fill([50,0,0])

    @background.draw @screen
    @player.draw @screen
    @enemy.draw @screen

    @screen.flip
  end
end

game = Game.new
game.run!