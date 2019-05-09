# Make sure to have the server side running in V-REP: 
# in a child script of a V-REP scene, add following command
# to be executed just once, at simulation start:
#
# simRemoteApi.start(19999)
#
# then start simulation, and run this program.
#
# IMPORTANT: for each successful call to simxStart, there
# should be a corresponding call to simxFinish at the end!

try:
    import vrep
except:
    print ('--------------------------------------------------------------')
    print ('"vrep.py" could not be imported. This means very probably that')
    print ('either "vrep.py" or the remoteApi library could not be found.')
    print ('Make sure both are in the same folder as this file,')
    print ('or appropriately adjust the file "vrep.py"')
    print ('--------------------------------------------------------------')
    print ('')

import time
from math import *


def moveLeftArm(targetPosition):
    emptyBuff = bytearray()
    res,retInts,retFloats,retStrings,retBuffer = vrep.simxCallScriptFunction(
        clientID, 
        'base_link_L_visual', 
        vrep.sim_scripttype_childscript,
        'commandLeftArm', [], targetPosition, [],
        emptyBuff,
        vrep.simx_opmode_blocking
    )
    if res==vrep.simx_return_ok:
        print ('Return string: ',retStrings[0]) # display the reply from V-REP (in this case, just a string)
    else:
        print ('Remote function call failed')
    return res



if __name__ == "__main__":
    print ('Program started')
    vrep.simxFinish(-1) # just in case, close all opened connections
    clientID=vrep.simxStart('127.0.0.1',19999,True,True,5000,5) # Connect to V-REP
    if clientID!=-1:
        print ('Connected to remote API server')

        # Now try to retrieve data in a blocking fashion (i.e. a service call):
        res,objs=vrep.simxGetObjects(clientID,vrep.sim_handle_all,vrep.simx_opmode_blocking)
        if res==vrep.simx_return_ok:
            print ('Number of objects in the scene: ',len(objs))
        else:
            print ('Remote API function call returned with error code: ',res)

        time.sleep(2)

        # Send a command to move the Left arm of Raven2 robot
        homePosition = [0,0,0,0,0,0]
        moveLeftArm([45*pi/180, -45*pi/180, -90*pi/180, 45*pi/180, 45*pi/180, 45*pi/180])
        moveLeftArm(homePosition)

        # Before closing the connection to V-REP, make sure that the last command sent out had time to arrive. You can guarantee this with (for example):
        vrep.simxGetPingTime(clientID)

        # Now close the connection to V-REP:
        vrep.simxFinish(clientID)
    else:
        print ('Failed connecting to remote API server')
    print ('Program ended')