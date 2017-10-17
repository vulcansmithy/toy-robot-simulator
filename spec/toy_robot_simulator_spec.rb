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
      result = @toy_robot.process_command(command)
      expect(result[:validity]).to eq true  
    end
  end
  
  it "be able to validate the 'place' command" do
    [
      "PLACE 0,0,NORTH",
      "PLACE 0,0,SOUTH",
      "PLACE 0,0,WEST",
      "PLACE 0,0,EAST",

      "PLACE 4,4,NORTH",
      "PLACE 4,4,SOUTH",
      "PLACE 4,4,WEST",
      "PLACE 4,4,EAST",
    ].each do |command|
      result = @toy_robot.process_command(command)
      expect(result[:validity]).to  eq true  
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
      
      # expect to catch typo on facing value
      "PLACE 0,0,NORTHH",
      "PLACE 0,0,southh",
      "PLACE 0,0,westT",
      "Place 0,0,EASTt",
      
      # expect to catch out of bound coordinates
      "PLACE 5,4,NORTH",
      "PLACE 4,5,NORTH",
      "PLACE 9,9,NORTH",
      
    ].each do |command|
      result = @toy_robot.process_command(command)
      expect(result[:validity]).to  eq false  
    end
    
  end
  
  it "should be able to successfully run execute_place_command with a valid x and y position" do
    
    # make sure point_x, point_y and facing_at are initialize state of nil
    expect(@toy_robot.point_x  ).to eq nil
    expect(@toy_robot.point_y  ).to eq nil
    expect(@toy_robot.facing_at).to eq nil  
    
    # call execute_place_command and set position to the origin position and facing north
    result = @toy_robot.execute_place_command(0, 0, "north")
    
    expect(result              ).to eq true
    expect(@toy_robot.point_x  ).to eq 0
    expect(@toy_robot.point_y  ).to eq 0
    expect(@toy_robot.facing_at).to eq "NORTH"
    
    # call execute_place_command and give a new position and now facing west
    result = @toy_robot.execute_place_command(4, 0, "west")
    
    expect(result              ).to eq true
    expect(@toy_robot.point_x  ).to eq 4
    expect(@toy_robot.point_y  ).to eq 0
    expect(@toy_robot.facing_at).to eq "WEST"
      
    # call execute_place_command and give a new position and now facing west
    result = @toy_robot.execute_place_command(4, 4, "south")
    
    expect(result              ).to eq true
    expect(@toy_robot.point_x  ).to eq 4
    expect(@toy_robot.point_y  ).to eq 4
    expect(@toy_robot.facing_at).to eq "SOUTH"
    
    # call execute_place_command and give a new position and now facing west
    result = @toy_robot.execute_place_command(0, 4, "east")
    
    expect(result              ).to eq true
    expect(@toy_robot.point_x  ).to eq 0
    expect(@toy_robot.point_y  ).to eq 4
    expect(@toy_robot.facing_at).to eq "EAST"
  end
  
  it "should ignore the command when running execute_place_command when given an out of bound x and y position" do
    
    # make sure point_x, point_y and facing_at are initialize state of nil
    expect(@toy_robot.point_x  ).to eq nil
    expect(@toy_robot.point_y  ).to eq nil
    expect(@toy_robot.facing_at).to eq nil
    
    # call execute_place_command and set position to the origin position and facing north
    result = @toy_robot.execute_place_command(2, 3, "north")
    
    expect(result              ).to eq true
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 3
    expect(@toy_robot.facing_at).to eq "NORTH"
    
    # call execute_place_command and give it a position that is out of bound
    result = @toy_robot.execute_place_command(3, 5, "east")
    
    expect(result              ).to eq false
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 3
    expect(@toy_robot.facing_at).to eq "NORTH"
    
    # call execute_place_command and give it a position that is out of bound
    result = @toy_robot.execute_place_command(5, 1, "east")
    
    expect(result              ).to eq false
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 3
    expect(@toy_robot.facing_at).to eq "NORTH"
    
    # call execute_place_command and give it a position that is out of bound
    result = @toy_robot.execute_place_command(-1, 3, "east")
    
    expect(result              ).to eq false
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 3
    expect(@toy_robot.facing_at).to eq "NORTH"
  end

end