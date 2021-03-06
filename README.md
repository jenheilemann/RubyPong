# RubyPong README #

## What is RubyPong? ##

RubyPong is a simple Pong clone, with a few additions in color, game speeds,
music, and settings screens. It's based on the tutorial by Tyler J Church at
ManWithCode.com, with some changes, additions and tweaks by yours truly. It's
built in Ruby, and runs on the Rubygame gem.

### Links ###
1. ManWithCode Tutorial: http://manwithcode.com/making-games-with-ruby/ and
http://devel.manwithcode.com/making-games-with-ruby.html
2. [Rubygame](http://rubygame.org)
3. [Ruby](http://www.ruby-lang.org)

## Requirements ##

Until I create an installer for this game, you'll need to install:

* Ruby = 1.9.3, 2.0.0 (this is what I've tested, it make work with other versions)
* Rubygame = 2.6.4
* Ruby-sdl-ffi gem, found at https://github.com/xrs1133/ruby-sdl-ffi

If you have RVM, you can simply do:

    $ cd rubyGame
    $ rvm install 2.0.0
    $ rvm use 2.0.0@rubygame --create
    $ gem install bundler
    $ bundle install

## Running the Game ##

    $ ruby ruby-pong.rb

## Licenses ##

RubyPong is copyright (c) 2013, Sierra Bravo Corp., dba The Nerdery. All rights
reserved. See the LICENSE file for more information about this program's
licensing.

The background music file is [RoboWizard[EC]](http://www.newgrounds.com/audio/listen/338715) by the user _EmperorCharlemagne_ on http://newgrounds.com/, and is released under the [Creative Commons Attribution-Noncommercial-ShareAlike](http://creativecommons.org/licenses/by-nc-sa/3.0/) licence.

The "pop" sound when buttons are clicked and when the ball hits was created by
Tyler J Church and released into the public domain.

The ball.png file was created by myself, and released under the public domain.

The _Overlock_ font files were created by and copyrighted to Dario Manuel
Muhafara. See the OFL.txt file in the app/assets/fonts folder for the license
and more information.

## Thank you ##

If you feel moved to contribute, report a bug, or have a pull request, please
do so. I used this project as a learning process, and am certain there are
many improvements and suggestions that can be made.

I primarily built this project during down time at my job with [The Nerdery](http://nerdery.com).
I am immensely thankful for a job that offers the opportunity to learn new
skills and expand my knowledge. So, big shout out to the Nerds!

Thank you.

Jen Heilemann (contact at jenheilemann.com)

