-- if you wish to execute code contained in an external file instead,
-- use the require-directive, e.g.:
--
-- require 'myExternalFile'
--
-- Above will look for <V-REP executable path>/myExternalFile.lua or
-- <V-REP executable path>/lua/myExternalFile.lua
-- (the file can be opened in this editor with the popup menu over
-- the file name)

leftArmObjHandle = sim.getObjectHandle('base_link_L_visual')
leftArmScriptHandle = sim.getScriptAssociatedWithObject(leftArmObjHandle)
leftToolDummyTarget = sim.getObjectHandle("left_tool_target")

rightArmObjHandle = sim.getObjectHandle('base_link_R_visual')
rightArmScriptHandle = sim.getScriptAssociatedWithObject(rightArmObjHandle)
rightToolDummyTarget = sim.getObjectHandle("right_tool_target")

examplesObjHandle = sim.getObjectHandle('examples')
examplesScriptHandle = sim.getScriptAssociatedWithObject(examplesObjHandle)


function sysCall_init()
    xml = [[
    <ui closeable="true" on-close="closeEventHandler" resizable="true" size="400,450" title="Raven 2 UI">
        <tabs>
            <tab title="Forward Kinematics">
                <label text="You must have IK groups disabled (Deselect from Inverse kinematics dialog)" />
                <tabs>
                    <tab title="Left arm">
                        <group layout="vbox">
                            <label text="shoulder [deg]" />
                            <hslider id="1001" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onLeftArmJointsChange"/>
                            <label text="elbow [deg]" />
                            <hslider id="1002" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onLeftArmJointsChange"/>
                            <label text="insertion [x100 micrometers]" />
                            <hslider id="1003" tick-position="below" tick-interval="1000" minimum="-17000" maximum="7000" on-change="onLeftArmJointsChange"/>
                            <label text="tool roll [deg]" />
                            <hslider id="1004" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onLeftArmJointsChange"/>
                            <label text="wrist joint [deg]" />
                            <hslider id="1005" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onLeftArmJointsChange"/>
                            <label text="grasper [deg]" />
                            <hslider id="1006" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onLeftArmJointsChange"/>
                        </group>
                    </tab>
                    <tab title="Right arm">
                        <group layout="vbox">
                            <label text="shoulder [deg]" />
                            <hslider id="2001" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onRightArmJointsChange"/>
                            <label text="elbow [deg]" />
                            <hslider id="2002" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onRightArmJointsChange"/>
                            <label text="insertion [x100 micrometers]" />
                            <hslider id="2003" tick-position="below" tick-interval="1000" minimum="-17000" maximum="7000" on-change="onRightArmJointsChange"/>
                            <label text="tool roll [deg]" />
                            <hslider id="2004" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onRightArmJointsChange"/>
                            <label text="wrist joint [deg]" />
                            <hslider id="2005" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onRightArmJointsChange"/>
                            <label text="grasper [deg]" />
                            <hslider id="2006" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onRightArmJointsChange"/>
                        </group>
                    </tab>
                </tabs>
                <stretch />
            </tab>


            <tab title="Inverse Kinematics">
                <label text="You must have IK groups enabled (Select from Inverse kinematics dialog)" />
                <tabs>
                    <tab title="Left arm">
                        <group layout="vbox">
                            <label text="X [x100 micrometers]" />
                            <hslider id="3001" tick-position="below" tick-interval="200" minimum="-2500" maximum="2500" on-change="onLeftArmTargetPosChange"/>
                            <label text="Y [x100 micrometers]" />
                            <hslider id="3002" tick-position="below" tick-interval="200" minimum="-2500" maximum="2500" on-change="onLeftArmTargetPosChange"/>
                            <label text="Z [x100 micrometers]" />
                            <hslider id="3003" tick-position="below" tick-interval="200" minimum="0" maximum="5000" on-change="onLeftArmTargetPosChange"/>
                            <label text="Yaw (alpha) [deg]" />
                            <hslider id="3004" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onLeftArmTargetPosChange"/>
                            <label text="Pitch (beta) [deg]" />
                            <hslider id="3005" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onLeftArmTargetPosChange"/>
                            <label text="Roll (gamma) [deg]" />
                            <hslider id="3006" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onLeftArmTargetPosChange"/>
                        </group>
                    </tab>
                    <tab title="Right arm">
                        <group layout="vbox">
                            <label text="X [x100 micrometers]" />
                            <hslider id="4001" tick-position="below" tick-interval="200" minimum="-2500" maximum="2500" on-change="onRightArmTargetPosChange"/>
                            <label text="Y [x100 micrometers]" />
                            <hslider id="4002" tick-position="below" tick-interval="200" minimum="-2500" maximum="2500" on-change="onRightArmTargetPosChange"/>
                            <label text="Z [x100 micrometers]" />
                            <hslider id="4003" tick-position="below" tick-interval="200" minimum="0" maximum="5000" on-change="onRightArmTargetPosChange"/>
                            <label text="Yaw (alpha) [deg]" />
                            <hslider id="4004" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onRightArmTargetPosChange"/>
                            <label text="Pitch (beta) [deg]" />
                            <hslider id="4005" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onRightArmTargetPosChange"/>
                            <label text="Roll (gamma) [deg]" />
                            <hslider id="4006" tick-position="below" tick-interval="10" minimum="-180" maximum="180" on-change="onRightArmTargetPosChange"/>
                        </group>
                    </tab>
                </tabs>
                <stretch />
            </tab>


            <tab title="Examples">
                <group layout="vbox">
                    <label text="Example 1" />
                    <button text="Run" id="5001" on-click="runExample1" />
                </group>
                <stretch />
            </tab>

            <tab title="RemoteAPI">
                <group layout="vbox">
                        
                </group>
                <stretch />
            </tab>

            <tab title="ROS">
                <group layout="vbox">
                        
                </group>
                <stretch />
            </tab>
        </tabs>
    </ui>
    ]]
	  
    ui = simUI.create(xml)

    -- Set initial values to UI sliders

    -- x,y,z of left_tool_target dummy
    leftToolDummyTargetPos = sim.getObjectPosition(leftToolDummyTarget, -1)
    for i=1,3,1 do
        simUI.setSliderValue(ui, 3000+i, leftToolDummyTargetPos[i])
    end
    -- alpha, beta, gamma of left_tool_target dummy
    leftToolDummyTargetOrient = sim.getObjectOrientation(leftToolDummyTarget, -1)
    for i=1,3,1 do
        orientation = math.floor(leftToolDummyTargetOrient[i])*180/math.pi
        simUI.setSliderValue(ui, 3000+i, orientation)
    end

    -- x,y,z of right_tool_target dummy
    rightToolDummyTargetPos = sim.getObjectPosition(rightToolDummyTarget, -1)
    for i=1,3,1 do
        simUI.setSliderValue(ui, 4000+i, rightToolDummyTargetPos[i])
    end
    -- alpha, beta, gamma of right_tool_target dummy
    rightToolDummyTargetOrient = sim.getObjectOrientation(rightToolDummyTarget, -1)
    for i=1,3,1 do
        orientation = math.floor(rightToolDummyTargetOrient[i])*180/math.pi
        simUI.setSliderValue(ui, 4000+i, orientation)
    end
   
end

function sleep(time)
    local sec = tonumber(os.clock() + time);
    while (os.clock() < sec) do
    end
    return
end

function onLeftArmJointsChange(ui, id, newVal)
    newPosition = {0,0,0,0,0,0}
    for i = 1001,1006,1 do
        newPosition[i-1000] = simUI.getSliderValue(ui, i) * math.pi/180
    end
    print(newPosition)

    inInts,inFloats,inStrings,inBuffer = sim.callScriptFunction('commandLeftArm@base_link_L_visual', leftArmScriptHandle, {}, newPosition, {}, {})
    print(inStrings[1])
    return
end

function onRightArmJointsChange(ui, id, newVal)
    newPosition = {0,0,0,0,0,0}
    for i = 2001,2006,1 do
        newPosition[i-2000] = simUI.getSliderValue(ui, i) * math.pi/180
    end
    print(newPosition)

    inInts,inFloats,inStrings,inBuffer = sim.callScriptFunction('commandRightArm@base_link_R_visual', rightArmScriptHandle, {}, newPosition, {}, {})
    print(inStrings[1])
    return
end

function runExample1(ui, id)
    runExample1Flag = 1
    sim.setIntegerSignal("runExample1Flag", runExample1Flag)
    return
end

function onLeftArmTargetPosChange(ui, id, newVal)
    newPosition = {0,0,0}
    newOrientation = {0,0,0}
    for i = 3001,3003,1 do
        newPosition[i-3000] = simUI.getSliderValue(ui, i) / 10000
    end
    for i = 3004,3006,1 do
        newOrientation[i-3003] = simUI.getSliderValue(ui, i) * math.pi/180
    end
    print(newPosition, newOrientation)

    sim.setObjectPosition(leftToolDummyTarget, -1, newPosition)
    sim.setObjectOrientation(leftToolDummyTarget, -1, newOrientation)

    return
end

function onRightArmTargetPosChange(ui, id, newVal)
    newPosition = {0,0,0}
    newOrientation = {0,0,0}
    for i = 4001,4003,1 do
        newPosition[i-4000] = simUI.getSliderValue(ui, i) / 10000
    end
    for i = 4004,4006,1 do
        newOrientation[i-4003] = simUI.getSliderValue(ui, i) * math.pi/180
    end
    print(newPosition, newOrientation)

    sim.setObjectPosition(rightToolDummyTarget, -1, newPosition)
    sim.setObjectOrientation(rightToolDummyTarget, -1, newOrientation)

    return
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

function closeEventHandler()
    simUI.hide(ui)
end

function sysCall_cleanup()
    -- do some clean-up here
    simUI.destroy(ui)
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
