require 'map'

class Controller
  def initialize(hostname, port)
    @hostname = hostname
    @port = port
  end
  
  def connect
    @connection = # socket.connnect @hostname @port
  end
  
  def end_of_run
    @running = false
  end
  
  def init(dx, dy, time_limit, min_sensor, max_sensor, max_speed, max_turn, max_hard_turn)
    @running = true
    @map ||= @map.new(dx, dy)
    @rover = Rover.new(min_sensor, max_sensor, max_speed, max_turn, max_hard_turn, @connection)
    @map.rover = @rover
  end
  
  def killed
  end
  
  def message_waiting?
    #socket.peek or something?
  end
  
  def react
    @map.steer_for_home! if @running
  end
  
  def run
    connect
    loop do
      if message_waiting?
        update
      end
      react
    end
  end
  
  def success
  end
  
  def telemetry(timestamp, vehicle_status, x, y, dir, speed, *obj)
    @rover.update(timestamp, vehicle_status, x, y, dir, speed)
    while true
      case obj.shift
      when 'b': @map.see_static(:boulder, obj.shift, obj.shift, obj.shift)
      when 'c': @map.see_static(:crater, obj.shift, obj.shift, obj.shift)
      when 'h': @map.see_static(:home, obj.shift, obj.shift, obj.shift)
      when 'm': @map.see_martian(obj.shift, obj.shift, obj.shift, obj.shift)
      else break
      end
    end
  end
  
  def update
    msg = #socket.read.split(/ +/)
    raise 'whoops' unless msg.pop.chomp == ';'
    case msg.shift
    when 'I': init(*msg)
    when 'T': telemetry(*msg)
    when 'B': crash(*msg)
    when 'C', 'K': killed()
    when 'S': success()
    when 'E': end_of_run(*msg)
    end
  end
  
end
