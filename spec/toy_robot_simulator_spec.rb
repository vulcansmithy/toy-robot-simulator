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
  
  it "should be able to successfully call execute_place_command with a valid x and y position" do
    
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
  
  it "should ignore the command when calling the execute_place_command when given an x and y position is out of bound" do
    
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

  it "should ignore the command execute_report_commmand when the current x and y position is not yet set with initial place position" do
    
    # make sure point_x, point_y and facing_at are initialize state of nil
    expect(@toy_robot.point_x  ).to eq nil
    expect(@toy_robot.point_y  ).to eq nil
    expect(@toy_robot.facing_at).to eq nil
    
    # call execute_report_command
    result = @toy_robot.execute_report_command
    
    expect(result).to eq false
  end
  
  it "should be able to successfully call execute_move_command without the robot falling off the table" do
    
    # set the position to the bottom left corner and have it facing north
    @toy_robot.execute_place_command(0, 0, "north")
    
    # step 4 units facing north
    for step in 1..4 
      @toy_robot.execute_move_command
    end
    
    expect(@toy_robot.point_x).to eq 0
    expect(@toy_robot.point_y).to eq 4
    
    # move again 1 step facing north
    @toy_robot.execute_move_command
    
    # expect not to fall off the table
    expect(@toy_robot.point_x).to eq 0
    expect(@toy_robot.point_y).to eq 4
    
    
    
    # set the position to the top most left corner and have it facing east
    @toy_robot.execute_place_command(0, 4, "east")
    
    # step 4 units facing east
    for step in 1..4 
      @toy_robot.execute_move_command
    end
    
    expect(@toy_robot.point_x).to eq 4
    expect(@toy_robot.point_y).to eq 4
    
    # move again 1 step facing east
    @toy_robot.execute_move_command
    
    # expect not to fall off the table
    expect(@toy_robot.point_x).to eq 4
    expect(@toy_robot.point_y).to eq 4
    
    
    
    # set the position to the top most right corner and have it facing south
    @toy_robot.execute_place_command(4, 4, "south")
    
    # step 4 units facing south
    for step in 1..4 
      @toy_robot.execute_move_command
    end
    
    expect(@toy_robot.point_x).to eq 4
    expect(@toy_robot.point_y).to eq 0
    
    # move again 1 step facing south
    @toy_robot.execute_move_command
    
    # expect not to fall off the table
    expect(@toy_robot.point_x).to eq 4
    expect(@toy_robot.point_y).to eq 0
    
    
    
    # set the position to the bottom right most corner and have it facing west
    @toy_robot.execute_place_command(4, 0, "west")
    
    # step 4 units facing west
    for step in 1..4 
      @toy_robot.execute_move_command
    end
    
    expect(@toy_robot.point_x).to eq 0
    expect(@toy_robot.point_y).to eq 0
    
    # move again 1 step facing west
    @toy_robot.execute_move_command
    
    # expect not to fall off the table
    expect(@toy_robot.point_x).to eq 0
    expect(@toy_robot.point_y).to eq 0
  end
  
  it "should be able to successfully call execute_left_command and the robot will be facing at the right direction" do
    
    # set the position at middle of the table
    @toy_robot.execute_place_command(2, 2, "north")
    
    # turn left
    @toy_robot.execute_left_command
    
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 2
    expect(@toy_robot.facing_at).to eq "WEST"
    
    # turn left again
    @toy_robot.execute_left_command
    
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 2
    expect(@toy_robot.facing_at).to eq "SOUTH"
    
    # turn left again
    @toy_robot.execute_left_command
    
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 2
    expect(@toy_robot.facing_at).to eq "EAST"
    
    # turn left again
    @toy_robot.execute_left_command
    
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 2
    expect(@toy_robot.facing_at).to eq "NORTH"
  end
  
  it "should be able to successfully call execute_right_command and the robot will be facing at the right direction" do
    
    # set the position at middle of the table
    @toy_robot.execute_place_command(2, 2, "north")
    
    # turn right
    @toy_robot.execute_right_command
    
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 2
    expect(@toy_robot.facing_at).to eq "EAST"
    
    # turn right again
    @toy_robot.execute_right_command
    
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 2
    expect(@toy_robot.facing_at).to eq "SOUTH"
    
    # turn right again
    @toy_robot.execute_right_command
    
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 2
    expect(@toy_robot.facing_at).to eq "WEST"
    
    # turn right again
    @toy_robot.execute_right_command
    
    expect(@toy_robot.point_x  ).to eq 2
    expect(@toy_robot.point_y  ).to eq 2
    expect(@toy_robot.facing_at).to eq "NORTH"
  end  
  
  it "should perfom Example A as specified in the PDF document" do
      
    expect(@toy_robot.execute_place_command(0, 0, "north")).to eq true
    
    expect(@toy_robot.execute_move_command).to eq true  
    
    expect(@toy_robot.execute_report_command).to eq true 
    
    expect(@toy_robot.point_x  ).to eq 0
    expect(@toy_robot.point_y  ).to eq 1
    expect(@toy_robot.facing_at).to eq "NORTH"
  end
  
  it "should perfom Example B as specified in the PDF document" do
    
    expect(@toy_robot.execute_place_command(0, 0, "north")).to eq true
    
    expect(@toy_robot.execute_left_command).to eq true  
    
    expect(@toy_robot.execute_report_command).to eq true 
    
    expect(@toy_robot.point_x  ).to eq 0
    expect(@toy_robot.point_y  ).to eq 0
    expect(@toy_robot.facing_at).to eq "WEST"
  end
  
  it "should perfom Example C as specified in the PDF document" do
    
    expect(@toy_robot.execute_place_command(1, 2, "east")).to eq true
    
    expect(@toy_robot.execute_move_command  ).to eq true 
    expect(@toy_robot.execute_move_command  ).to eq true 
    expect(@toy_robot.execute_left_command  ).to eq true  
    expect(@toy_robot.execute_move_command  ).to eq true 
    expect(@toy_robot.execute_report_command).to eq true 
    
    expect(@toy_robot.point_x  ).to eq 3
    expect(@toy_robot.point_y  ).to eq 3
    expect(@toy_robot.facing_at).to eq "NORTH"
  end
end