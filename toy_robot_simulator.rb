require File.dirname(__FILE__) + "/toy_robot_simulator.rb"

# this enable this ruby script to be run from the command output. Example - $> ruby toy_robot_simulator.rb
if __FILE__ == $PROGRAM_NAME
  ToyRobotSimulator.new.main 
end

class ToyRobotSimulator
  
  def main
    
    while (entry = command_prompt("Enter command: ")).downcase != "quit" do
      puts "You entered '#{entry}'..."
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
    command.downcase!
    
    if command.scan(/^place/i).first == "place"
      return true
    elsif command.scan(/^move/i).first == "move"  
      return true
    elsif command.scan(/^left/i).first == "left"
      return true
    elsif command.scan(/^right/i).first == "right"
      return true  
    elsif command.scan(/^report/i).first == "report"
      return true
    elsif command.scan(/^quit/i).first == "quit" 
      return true
    else
      return false
    end           
  end  
  
end