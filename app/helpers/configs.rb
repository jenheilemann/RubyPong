class Configs

  def initialize(file)
    @file = file
    @settings = YAML.load(File.read(file))
  end

  def [](key)
    @settings[key]
  end

  def []=(key,value)
    @settings[key] = value
  end

  def save
    File.open(@file, "w") do |file|
      file.puts YAML.dump @settings
    end
  end

  def reset
    @settings = {
      winning_score: 3,
      game_speed:    5,
      music:         true,
      sound_fx:      true,
    }
    save
  end
end