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

end