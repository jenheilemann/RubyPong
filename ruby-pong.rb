require './config/environment.rb'

game = Game.new()
game.switch_state( TitleController.new(game) )
game.run!