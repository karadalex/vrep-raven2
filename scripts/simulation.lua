-- if you wish to execute code contained in an external file instead,
-- use the require-directive, e.g.:
--
-- require 'myExternalFile'
--
-- Above will look for <V-REP executable path>/myExternalFile.lua or
-- <V-REP executable path>/lua/myExternalFile.lua
-- (the file can be opened in this editor with the popup menu over
-- the file name)

function sysCall_init()
    -- Initialization code:
    -- Set global variables (signals)
    rightArmHandles = {-1,-1,-1,-1,-1,-1}
    rightArmHandles[1] = sim.getObjectHandle('shoulder_R')
    rightArmHandles[2] = sim.getObjectHandle('elbow_R')
    rightArmHandles[3] = sim.getObjectHandle('insertion_R')
    rightArmHandles[4] = sim.getObjectHandle('tool_roll_R')
    rightArmHandles[5] = sim.getObjectHandle('wrist_joint_R')
    rightArmHandles[6] = sim.getObjectHandle('grasper_joint_1_R')
    sim.setStringSignal("rightArmHandles", sim.packTable(rightArmHandles))

    leftArmHandles = {-1,-1,-1,-1,-1,-1}
    leftArmHandles[1] = sim.getObjectHandle('shoulder_L')
    leftArmHandles[2] = sim.getObjectHandle('elbow_L')
    leftArmHandles[3] = sim.getObjectHandle('insertion_L')
    leftArmHandles[4] = sim.getObjectHandle('tool_roll_L')
    leftArmHandles[5] = sim.getObjectHandle('wrist_joint_L')
    leftArmHandles[6] = sim.getObjectHandle('grasper_joint_1_L')
    sim.setStringSignal("leftArmHandles", sim.packTable(leftArmHandles))
    
end

function sysCall_actuation()
    -- put your actuation code here
    --
    -- For example:
    --
    -- local position=sim.getObjectPosition(handle,-1)
    -- position[1]=position[1]+0.001
    -- sim.setObjectPosition(handle,-1,position)
end

function sysCall_sensing()
    -- put your sensing code here
end

function sysCall_cleanup()
    -- do some clean-up here
end

-- You can define additional system calls here:
--[[
function sysCall_suspend()
end

function sysCall_resume()
end

function sysCall_dynCallback(inData)
end

function sysCall_jointCallback(inData)
    return outData
end

function sysCall_contactCallback(inData)
    return outData
end

function sysCall_beforeCopy(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." will be copied")
    end
end

function sysCall_afterCopy(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." was copied")
    end
end

function sysCall_beforeDelete(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." will be deleted")
    end
    -- inData.allObjects indicates if all objects in the scene will be deleted
end

function sysCall_afterDelete(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." was deleted")
    end
    -- inData.allObjects indicates if all objects in the scene were deleted
end

function sysCall_afterCreate(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..value.." was created")
    end
end
--]]
