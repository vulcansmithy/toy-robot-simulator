require "spec_helper"
 
describe ToyRobotSimulator do
  
  before :each do
    @toy_robot = ToyRobotSimulator.new
  end  
  
  it "be able validate valid commands" do
    valid_commands = [
      "PLACE 0,0,NORTH",
      "MOVE",
      "LEFT",
      "RIGHT",
      "REPORT",
      "QUIT"
    ]
    
    valid_commands.each do |command|
      expect(@toy_robot.process_command(command)).to eq true  
    end
  end
  
  it "be able to validate the 'place' command" do
    [
      "PLACE 0,0,NORTH",
      "PLACE 0,0,SOUTH",
      "PLACE 0,0,WEST",
      "PLACE 0,0,EAST",
    ].each do |command|
      expect(@toy_robot.process_command(command)).to  eq true  
    end
    
    
    [
      # expect the command entry format to be 'PLACE x,y,[valid facing value]'
      "PLACE0,0,NORTH",
      "PLACE 0.0,NORTH",
      "PLACE 0,0.NORTH",
      "PLACE 0.0.NORTH",
      "PLACE0,0,NORTH",
      
      # expect the x and y coordinate to be single digit
      "PLACE 00,0,NORTH",
      "PLACE 0,00,NORTH",

      # expect to have a facing value
      "PLACE 0,0,",
      "PLACE 0,0",
            
      # expect the facing value to only be 'NORTH', 'SOUTH', 'WEST', and 'EAST'
      "PLACE 0,0,LOREM",
      "PLACE 0,0,sout",
    ].each do |command|
      expect(@toy_robot.process_command(command)).to  eq false  
    end
    
  end

end