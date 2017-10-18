require File.dirname(__FILE__) + "/toy_robot_simulator.rb"

# this enable this ruby script to be run from the command output. Example - $> ruby toy_robot_simulator.rb
if __FILE__ == $PROGRAM_NAME
  ToyRobotSimulator.new.main 
end

class ToyRobotSimulator
  
  NORTH_DIRECTION = "NORTH"
  SOUTH_DIRECTION = "SOUTH"
   WEST_DIRECTION = "WEST"
   EAST_DIRECTION = "EAST"
   
    MOVE_COMMAND  = "move" 
    LEFT_COMMAND  = "left"
   RIGHT_COMMAND  = "right"
  REPORT_COMMAND  = "report" 
    QUIT_COMMAND  = "quit"
  
  attr_reader :point_x
  attr_reader :point_y
  attr_reader :facing_at
  
  def initialize
    @point_x   = nil
    @point_y   = nil
    @facing_at = nil
  end  
  
  def main
    while (entered_command = command_prompt("('QUIT' to exit): ")).downcase != QUIT_COMMAND do
      processed_result = process_command(entered_command)
       if processed_result[:validity]
        case processed_result[:command]
        when :place
          execute_place_command(processed_result[:point_x], processed_result[:point_y], processed_result[:facing_at])
        when :move
          execute_move_command
        when :left
          execute_left_command
        when :right
          execute_right_command
        when :report
          execute_report_command
        end
      end  
    end
    
    return 0
  end  
  
  def command_prompt(prompt_message="")
    print "#{prompt_message} "
    STDOUT.flush  
    entry = gets.chomp 
    
    return entry
  end
  
  def process_command(command)
    result = { validity: false }

    command.downcase!

    if command.scan(/^PLACE\s\d{1},\d{1},(NORTH|SOUTH|WEST|EAST)/i).empty? == false
      
      point_x = command.scan(/\d{1}/)[0].to_i
      point_y = command.scan(/\d{1}/)[1].to_i
      
      extracted = command.scan(/(NORTH\z|SOUTH\z|WEST\z|EAST\z)/i)
      facing_at = extracted.empty? ? nil : (extracted[0])[0]

      if (0..4).cover?(point_x) && (0..4).cover?(point_y) && facing_at.nil? == false
        result = { 
          validity:  true, 
          command:   :place, 
          point_x:   point_x, 
          point_y:   point_y, 
          facing_at: facing_at, 
        }
      else
        result = { validity: false }
      end 

    elsif command.scan(/^move/i).first == MOVE_COMMAND
      result = { validity: true, command: :move }

    elsif command.scan(/^left/i).first == LEFT_COMMAND
      result = { validity: true, command: :left }

    elsif command.scan(/^right/i).first == RIGHT_COMMAND
      result = { validity: true, command: :right }

    elsif command.scan(/^report/i).first == REPORT_COMMAND
      result = { validity: true, command: :report }

    elsif command.scan(/^quit/i).first == QUIT_COMMAND
      result = { validity: true, command: :quit }
    end
    
    return result      
  end 
  
  def execute_place_command(point_x, point_y, facing_at)
    status = false
    if (0..4).cover?(point_x) && (0..4).cover?(point_y)

      # make sure the value of facing_at is a valid compass direction
      if [NORTH_DIRECTION, SOUTH_DIRECTION, WEST_DIRECTION, EAST_DIRECTION].include?(facing_at.upcase)
        @point_x   = point_x
        @point_y   = point_y
        @facing_at = facing_at.upcase
        status     = true
      end
    end  

    return status
  end
  
  def execute_move_command 
    status = false
    if @point_x.nil? == false && @point_y.nil? == false
      direction = @facing_at.upcase
      case direction
      when NORTH_DIRECTION
        value = @point_y
        if (0..4).cover?(value + 1)
          @point_y += 1
          status = true
        end  
      when SOUTH_DIRECTION
        value = @point_y
        if (0..4).cover?(value - 1)
          @point_y -= 1
          status = true
        end    
      when WEST_DIRECTION
        value = @point_x
        if (0..4).cover?(value - 1)
          @point_x -= 1
          status = true
        end  
      when EAST_DIRECTION     
        value = @point_x
        if (0..4).cover?(value + 1)
          @point_x += 1
          status = true
        end  
      end
        
      status = true
    end    

    return status
  end

  def execute_left_command 
    status = false
    if @point_x.nil? == false && @point_y.nil? == false
      case @facing_at
      when NORTH_DIRECTION
        @facing_at = WEST_DIRECTION
        status = true
      when WEST_DIRECTION
        @facing_at = SOUTH_DIRECTION
        status = true
      when SOUTH_DIRECTION
        @facing_at = EAST_DIRECTION   
        status = true
      when EAST_DIRECTION
        @facing_at = NORTH_DIRECTION
        status = true
      end     
    end    

    return status
  end
  
  def execute_right_command 
    status = false
    if @point_x.nil? == false && @point_y.nil? == false
      case @facing_at
      when NORTH_DIRECTION
        @facing_at = EAST_DIRECTION
        status = true
      when EAST_DIRECTION
        @facing_at = SOUTH_DIRECTION
        status = true
      when SOUTH_DIRECTION
        @facing_at = WEST_DIRECTION   
        status = true
      when WEST_DIRECTION
        @facing_at = NORTH_DIRECTION
        status = true
      end     
    end    

    return status
  end
  
  def execute_report_command 
    status = false
    if @point_x.nil? == false && @point_y.nil? == false
      puts "OUTPUT: #{@point_x},#{@point_y},#{@facing_at}"
      status = true
    end    

    return status
  end
  
end