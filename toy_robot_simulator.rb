require File.dirname(__FILE__) + "/toy_robot_simulator.rb"

# this enable this ruby script to be run from the command output. Example - $> ruby toy_robot_simulator.rb
if __FILE__ == $PROGRAM_NAME
  ToyRobotSimulator.new.main 
end

class ToyRobotSimulator
  
  def initialize
    @x_coordinate = nil
    @y_coordinate = nil
    @facing       = nil
  end  
  
  def main
    while (entered_command = command_prompt("Enter command: ")).downcase != "quit" do
      result = process_command(entered_command)
       if result[:validity]
        case result[:command]
        when :place
          execute_place_command(result[:x_coordinate], result[:y_coordinate], result[:facing])
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
      
      x_coordinate = command.scan(/\d{1}/)[0].to_i
      y_coordinate = command.scan(/\d{1}/)[1].to_i
      
      extracted = command.scan(/(NORTH\z|SOUTH\z|WEST\z|EAST\z)/i)
      facing_at = extracted.empty? ? nil : extracted[0]

      if (0..4).cover?(x_coordinate) && (0..4).cover?(y_coordinate) && facing_at.nil? == false
        result = { 
          validity:     true, 
          command:      :place, 
          x_coordinate: x_coordinate, 
          y_coordinate: y_coordinate, 
          facing:       facing_at, 
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
  
  def execute_place_command(x_coordinate, y_coordinate, facing_at)
    puts "@DEBUG #{__LINE__}    Running execute_place_command..."
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
    puts "@DEBUG #{__LINE__}    Running report_command..."
  end
  
end