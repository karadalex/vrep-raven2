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
rightArmObjHandle = sim.getObjectHandle('base_link_R_visual')
rightArmScriptHandle = sim.getScriptAssociatedWithObject(rightArmObjHandle)
examplesObjHandle = sim.getObjectHandle('examples')
examplesScriptHandle = sim.getScriptAssociatedWithObject(examplesObjHandle)


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
    inInts,inFloats,inStrings,inBuffer = sim.callScriptFunction('example1@examples', examplesScriptHandle, {}, {}, {}, {})
    print(inStrings[1])
    return
end


function sysCall_init()
    xml = [[
    <ui closeable="true" on-close="closeEventHandler" resizable="true" size="400,450" title="Raven 2 UI">
        <tabs>
            <tab title="Forward Kinematics">
                <tabs>
                    <tab title="Left arm">
                        <group layout="vbox">
                            <label text="shoulder" />
                            <hslider id="1001" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onLeftArmJointsChange"/>
                            <label text="elbow" />
                            <hslider id="1002" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onLeftArmJointsChange"/>
                            <label text="insertion" />
                            <hslider id="1003" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onLeftArmJointsChange"/>
                            <label text="tool roll" />
                            <hslider id="1004" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onLeftArmJointsChange"/>
                            <label text="wrist joint" />
                            <hslider id="1005" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onLeftArmJointsChange"/>
                            <label text="grasper" />
                            <hslider id="1006" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onLeftArmJointsChange"/>
                        </group>
                    </tab>
                    <tab title="Right arm">
                        <group layout="vbox">
                            <label text="shoulder" />
                            <hslider id="2001" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onRightArmJointsChange"/>
                            <label text="elbow" />
                            <hslider id="2002" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onRightArmJointsChange"/>
                            <label text="insertion" />
                            <hslider id="2003" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onRightArmJointsChange"/>
                            <label text="tool roll" />
                            <hslider id="2004" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onRightArmJointsChange"/>
                            <label text="wrist joint" />
                            <hslider id="2005" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onRightArmJointsChange"/>
                            <label text="grasper" />
                            <hslider id="2006" tick-position="below" tick-interval="10" minimum="0" maximum="90" on-change="onRightArmJointsChange"/>
                        </group>
                    </tab>
                </tabs>
                <stretch />
            </tab>


            <tab title="Inverse Kinematics">
                <group layout="vbox">
                        
                </group>
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
