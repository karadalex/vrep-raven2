-- if you wish to execute code contained in an external file instead,
-- use the require-directive, e.g.:
--
-- require 'myExternalFile'
--
-- Above will look for <V-REP executable path>/myExternalFile.lua or
-- <V-REP executable path>/lua/myExternalFile.lua
-- (the file can be opened in this editor with the popup menu over
-- the file name)

function sysCall_threadmain()
    -- Put some initialization code here
    

    -- Put your main loop here, e.g.:
    
    while sim.getSimulationState()~=sim.simulation_advancing_abouttostop do
        runExample1Flag = sim.getIntegerSignal("runExample1Flag")
        runExample2Flag = sim.getIntegerSignal("runExample2Flag")

        if runExample1Flag == 1 then
            example1()
            runExample1Flag = 0
            sim.setIntegerSignal("runExample1Flag", runExample1Flag)
        end
        if runExample2Flag == 1 then
            example2()
            runExample2Flag = 0
            sim.setIntegerSignal("runExample2Flag", runExample2Flag)
        end
        sim.switchThread() -- resume in next simulation step
    end
end

function sysCall_cleanup()
    -- Put some clean-up code here
end

--[[
    Example 1:
    Execute simple test paths in joint state for both arms
]]
function example1()
    leftArmHandles = sim.unpackTable(sim.getStringSignal("leftArmHandles"))
    rightArmHandles = sim.unpackTable(sim.getStringSignal("rightArmHandles"))

    -- Set-up some of the RML vectors:
    vel = 120
    accel = 40
    jerk = 80
    currentVel = {0,0,0,0,0,0}
    currentAccel = {0,0,0,0,0,0}
    maxVel = {
        vel*math.pi/180, vel*math.pi/180, vel*math.pi/180,
        vel*math.pi/180, vel*math.pi/180, vel*math.pi/180
    }
    maxAccel = {
        accel*math.pi/180, accel*math.pi/180, accel*math.pi/180,
        accel*math.pi/180, accel*math.pi/180, accel*math.pi/180
    }
    maxJerk = {
        jerk*math.pi/180, jerk*math.pi/180, jerk*math.pi/180,
        jerk*math.pi/180, jerk*math.pi/180, jerk*math.pi/180
    }
    targetVel = {0,0,0,0,0,0}

    pos1 = {45*math.pi/180, -45*math.pi/180, -90*math.pi/180, 45*math.pi/180, -45*math.pi/180, -90*math.pi/180}
    sim.rmlMoveToJointPositions(
        leftArmHandles, -1, 
        currentVel, currentAccel,
        maxVel, maxAccel, maxJerk,
        pos1, targetVel
    )
    sim.rmlMoveToJointPositions(
        rightArmHandles, -1, 
        currentVel, currentAccel,
        maxVel, maxAccel, maxJerk,
        pos1, targetVel
    )

    pos2 = {-45*math.pi/180, 45*math.pi/180, 90*math.pi/180, 0, 0, 0}
    sim.rmlMoveToJointPositions(
        leftArmHandles, -1, 
        currentVel, currentAccel,
        maxVel, maxAccel, maxJerk,
        pos2, targetVel
    )
    sim.rmlMoveToJointPositions(
        rightArmHandles, -1, 
        currentVel, currentAccel,
        maxVel, maxAccel, maxJerk,
        pos2, targetVel
    )

    homePos = {0,0,0,0,0,0}
    sim.rmlMoveToJointPositions(
        leftArmHandles, -1, 
        currentVel, currentAccel,
        maxVel, maxAccel, maxJerk,
        homePos, targetVel
    )
    sim.rmlMoveToJointPositions(
        rightArmHandles, -1, 
        currentVel, currentAccel,
        maxVel, maxAccel, maxJerk,
        homePos, targetVel
    )
    return {},{},{'Example1 was executed'},'' -- return a string
end

--[[
    Example 2:
    Liver palpation with both arms
    Command arms to follow the liverPalpationPath paths in task space
    Documentation on sim.followPath http://www.coppeliarobotics.com/helpFiles/en/regularApi/simFollowPath.htm
]]
function example2()
    leftToolDummyTarget = sim.getObjectHandle("left_tool_target")
    rightToolDummyTarget = sim.getObjectHandle("right_tool_target")

    liverPalpationPath1 = sim.getObjectHandle("liverPalpationPath1")
    liverPalpationPath2 = sim.getObjectHandle("liverPalpationPath2")

    vel = 2
    accel = 1
    sim.followPath(leftToolDummyTarget, liverPalpationPath1, 3, 0, vel, accel)
    sim.followPath(rightToolDummyTarget, liverPalpationPath2, 3, 0, vel, accel)
end

-- ADDITIONAL DETAILS:
-- -------------------------------------------------------------------------
-- If you wish to synchronize a threaded loop with each simulation pass,
-- enable the explicit thread switching with 
--
-- sim.setThreadAutomaticSwitch(false)
--
-- then use
--
-- sim.switchThread()
--
-- When you want to resume execution in next simulation step (i.e. at t=t+dt)
--
-- sim.switchThread() can also be used normally, in order to not waste too much
-- computation time in a given simulation step
-- -------------------------------------------------------------------------