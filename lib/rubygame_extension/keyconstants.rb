module Rubygame

  K_LCMD = 310
  K_RCMD = 309
  K_SUPERS = [
      K_LSUPER,
      K_RSUPER,
      K_LCMD,
      K_RCMD
    ]

  class << self

    def is_super_and(key, mods)
      return false if mods.count != 2

      K_SUPERS.each do |super_key|
        return true if mods.include?(super_key) && mods.include?(key)
      end
      false
    end
  end

end