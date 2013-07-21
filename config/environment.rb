require 'rubygame'
require 'yaml'


# set up image and asset loading for images
img_dir   = File.join(File.dirname(__FILE__),'..','app','assets','images')
Rubygame::Surface.autoload_dirs << img_dir

sound_dir = File.join(File.dirname(__FILE__),'..','app','assets','audio')
Rubygame::Sound.autoload_dirs << sound_dir
Rubygame::Music.autoload_dirs << sound_dir

# load TTF so fonts work!
Rubygame::TTF.setup

# Getting the autoloader and loading our folders
require File.dirname(__FILE__) + '/../lib/autoload/autoload'

autoload = Autoload.new(File.join(__FILE__,'..'))
autoload.require_all('lib')
autoload.require_all('app')