require File.dirname(__FILE__) + "/toy_robot_simulator.rb"

# this enable this ruby script to be run from the command output. Example - $> ruby toy_robot_simulator.rb
if __FILE__ == $PROGRAM_NAME
  ToyRobotSimulator.new.main 
end

class ToyRobotSimulator
  
  attr_reader :point_x
  attr_reader :point_y
  attr_reader :facing_at
  
  def initialize
    @point_x   = nil
    @point_y   = nil
    @facing_at = nil
  end  
  
  def main
    while (entered_command = command_prompt("('QUIT' to exit): ")).downcase != "quit" do
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
      facing_at = extracted.empty? ? nil : extracted[0]

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

    elsif command.scan(/^move/i).first == "move"
      result = { validity: true, command: :move }

    elsif command.scan(/^left/i).first == "left"
      result = { validity: true, command: :left }

    elsif command.scan(/^right/i).first == "right"
      result = { validity: true, command: :right }

    elsif command.scan(/^report/i).first == "report"
      result = { validity: true, command: :report }

    elsif command.scan(/^quit/i).first == "quit"
      result = { validity: true, command: :quit }
    end
    
    return result      
  end 
  
  def execute_place_command(point_x, point_y, facing_at)
    status = false
    if (0..4).cover?(point_x) && (0..4).cover?(point_y)

      # make sure the value of facing_at is a valid compass direction
      if ["north", "south", "west", "east"].include?(facing_at.downcase)
        @point_x   = point_x
        @point_y   = point_y
        @facing_at = facing_at.upcase
        status     = true
      end
    end  

    return status
  end
  
  def execute_move_command 
    puts "@DEBUG #{__LINE__}    Running move_command..."
  end

  def execute_left_command 
    puts "@DEBUG #{__LINE__}    Running left_command..."
  end
  
  def execute_right_command 
    puts "@DEBUG #{__LINE__}    Running right_command..."
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