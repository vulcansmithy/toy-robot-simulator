require File.dirname(__FILE__) + "/toy_robot_simulator.rb"

# this enable this ruby script to be run from the command output. Example - $> ruby toy_robot_simulator.rb
if __FILE__ == $PROGRAM_NAME
  ToyRobotSimulator.new.main 
end

class ToyRobotSimulator
  
  def main
    while (entered_command = command_prompt("Enter command: ")).downcase != "quit" do
      puts "You entered '#{entered_command}'..."
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
    validity = false
    command.downcase!
    
    if command.scan(/^PLACE\s\d{1},\d{1},(NORTH|SOUTH|WEST|EAST)/i).empty? == false
      validity = true
    elsif command.scan(/^move/i).first == "move"  
      validity = true
    elsif command.scan(/^left/i).first == "left"
      validity = true
    elsif command.scan(/^right/i).first == "right"
      validity = true 
    elsif command.scan(/^report/i).first == "report"
      validity = true
    elsif command.scan(/^quit/i).first == "quit" 
      validity = true
    end
    
    return validity       
  end  
  
end