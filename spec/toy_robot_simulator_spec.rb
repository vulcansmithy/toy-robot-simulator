require "spec_helper"
 
describe ToyRobotSimulator do
  
  before :each do
    @toy_robot = ToyRobotSimulator.new
  end  
  
  it "be able proccess a valid 'place' command" do
    command = "place 0,0,north"  
    expect(@toy_robot.proccess_command(command)).to eq true
  end

end