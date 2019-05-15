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
    rightArmFlag = false
    targetPosition = {0,0,0,0,0,0}

    commandRightArm = function(inInts,inFloats,inStrings,inBuffer)
        rightArmFlag = true
        if #inFloats==6 then
            targetPosition = inFloats
        end
        return {},{},{'Robot received command'},'' -- return a string
    end

    -- Put your main loop here, e.g.:
    --
    while sim.getSimulationState()~=sim.simulation_advancing_abouttostop do
        if rightArmFlag then
            moveRightArm(targetPosition)
        end
        sim.switchThread() -- resume in next simulation step
    end
end


function sysCall_cleanup()
    -- Put some clean-up code here
end


function moveRightArm(targetPos)
    rightArmHandles = {-1,-1,-1,-1,-1,-1}
    rightArmHandles[1] = sim.getObjectHandle('shoulder_R')
    rightArmHandles[2] = sim.getObjectHandle('elbow_R')
    rightArmHandles[3] = sim.getObjectHandle('insertion_R')
    rightArmHandles[4] = sim.getObjectHandle('tool_roll_R')
    rightArmHandles[5] = sim.getObjectHandle('wrist_joint_R')
    rightArmHandles[6] = sim.getObjectHandle('grasper_joint_1_R')

    -- Set-up some of the RML vectors:
    vel = 120
    accel = 40
    jerk = 80
    currentVel = {0,0,0,0,0,0}
    currentAccel = {0,0,0,0,0,0}
    maxVel = {
        vel*math.pi/180, vel*math.pi/180, vel*math.pi/180,
        0.5*vel*math.pi/180, 0.5*vel*math.pi/180, 0.5*vel*math.pi/180
    }
    maxAccel = {
        accel*math.pi/180, accel*math.pi/180, accel*math.pi/180,
        0.5*accel*math.pi/180, 0.5*accel*math.pi/180, 0.5*accel*math.pi/180
    }
    maxJerk = {
        jerk*math.pi/180, jerk*math.pi/180, jerk*math.pi/180,
        jerk*math.pi/180, jerk*math.pi/180, jerk*math.pi/180
    }
    targetVel = {0,0,0,0,0,0}

    -- targetPos = {45*math.pi/180, -45*math.pi/180, -90*math.pi/180}
    sim.rmlMoveToJointPositions(
        rightArmHandles, -1, 
        currentVel, currentAccel,
        maxVel, maxAccel, maxJerk,
        targetPos, targetVel
    )

    -- homePosition = {0, 0, 0}
    -- sim.rmlMoveToJointPositions(
    --     rightArmHandles, -1, 
    --     currentVel, currentAccel,
    --     maxVel, maxAccel, maxJerk,
    --     homePosition, targetVel
    -- )
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