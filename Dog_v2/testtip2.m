  vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
    vrep.simxFinish(-1); % just in case, close all opened connections
    clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
if (clientID>-1)
        disp('Connected to remote API server');
        
        [returnCode,target] = vrep.simxGetObjectHandle(clientID,'target',vrep.simx_opmode_blocking);
        [returnCode,base] = vrep.simxGetObjectHandle(clientID,'base',vrep.simx_opmode_blocking);
       % [returnCode,rightMotor] = vrep.simxGetObjectHandle(clientID,'motor_right',vrep.simx_opmode_blocking)
       % [returnCode,sensor] = vrep.simxGetObjectHandle(clientID,'front_prox',vrep.simx_opmode_blocking)
       % [f] = vrep.simxSetJointTargetVelocity(clientID,leftMotor,0.1,vrep.simx_opmode_oneshot);
      % [check,detectState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,,)
      %  pause(5)
       [returnCode t] = vrep.simxGetFloatSignal(clientID,'smt_time',vrep.simx_opmode_streaming);
       pr = 0;
        while(1>00)
            
            [~,t] = vrep.simxGetFloatSignal(clientID,'smt_time',vrep.simx_opmode_buffer);
            spp = mod(pr,1)
            a = 0.02 * sin(2*pi*spp);
            [~] = vrep.simxSetObjectPosition(clientID,target,base,[0 0 a],vrep.simx_opmode_oneshot)
            %[returnCode]=vrep.simxSetObjectPosition(clientID,hanuT(i),hanuC(i),[temp{i}(1) temp{i}(2) temp{i}(3) ],vrep.simx_opmode_oneshot);
            
            pr = pr +1.2*t;
           
            
        end
else
    disp('fail');
end
  
    disp('End');
 vrep.delete();