module Collisions
  def collision?(obj2, obj1 = self)
    return false if obj1.bottom < obj2.top    ||
                    obj1.top    > obj2.bottom ||
                    obj1.right  < obj2.left   ||
                    obj1.left   > obj2.right
    true
  end

  def inside?(point = [0,0], obj = self)
    return false if point[0] < obj.left  ||
                    point[0] > obj.right ||
                    point[1] < obj.top   ||
                    point[1] > obj.bottom
    true
  end
end