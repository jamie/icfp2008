class Map
  attr_accessor :rover
  
  def initialize(dx, dy)
    @min_x = -dx/2.0
    @max_x = dx/2.0
    @min_y = -dy/2.0
    @max_y = dy/2.0
  end
  
  def steer_for_home!
    
  end

  def see_static(kind, x, y, r)
    
  end
  
  def see_martian(x, y, dir, speed)
    
  end
  
end
