module Rubygame

  class BallScored < Event
    attr_reader :wall_passed, :screen
    def initialize(wall_passed, screen)
      @wall_passed = wall_passed
      @screen      = screen
    end
  end

  class ScoreEvent < Event
    attr_reader :player
    def initialize(player)
      @player = player
    end
  end

  class ButtonClickEvent < Event
    attr_reader :action
    def initialize(action)
      @action = action
    end
  end

end # module Rubygame