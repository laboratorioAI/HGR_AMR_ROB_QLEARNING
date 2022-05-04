
function [rotation1,rotation2,rotation3,rotation4,rotation5,rotation6,posicion] = Leer(vrep, clientID,driver_joint1_handle,driver_joint2_handle,driver_joint3_handle,driver_joint4_handle,driver_joint5_handle,driver_joint6_handle,TIP) 
%  [ReturnCode, posicion] = vrep.simxGetObjectPosition(clientID,end_effector_handle, reference_handle,vrep.simx_opmode_oneshot);

 [returnCode, posicion]   = vrep.simxGetObjectPosition(clientID, TIP, -1, vrep.simx_opmode_buffer);

%  [ReturnCode, rotation1] = vrep.simxGetJointPosition(clientID,driver_joint1_handle,vrep.simx_opmode_oneshot);
%  [ReturnCode, rotation2] = vrep.simxGetJointPosition(clientID,driver_joint2_handle,vrep.simx_opmode_oneshot);
%  [ReturnCode, rotation3] = vrep.simxGetJointPosition(clientID,driver_joint3_handle,vrep.simx_opmode_oneshot);
%  [ReturnCode, rotation4] = vrep.simxGetJointPosition(clientID,driver_joint4_handle,vrep.simx_opmode_oneshot);
%  [ReturnCode, rotation5] = vrep.simxGetJointPosition(clientID,driver_joint5_handle,vrep.simx_opmode_oneshot);
%  [ReturnCode, rotation6] = vrep.simxGetJointPosition(clientID,driver_joint6_handle,vrep.simx_opmode_oneshot);

[returnCode, rotation1] = vrep.simxGetJointPosition(clientID, driver_joint1_handle, vrep.simx_opmode_buffer);
[returnCode, rotation2] = vrep.simxGetJointPosition(clientID, driver_joint2_handle, vrep.simx_opmode_buffer);
[returnCode, rotation3] = vrep.simxGetJointPosition(clientID, driver_joint3_handle, vrep.simx_opmode_buffer);
[returnCode, rotation4] = vrep.simxGetJointPosition(clientID, driver_joint4_handle, vrep.simx_opmode_buffer);
[returnCode, rotation5] = vrep.simxGetJointPosition(clientID, driver_joint5_handle, vrep.simx_opmode_buffer);
[returnCode, rotation6] = vrep.simxGetJointPosition(clientID, driver_joint6_handle, vrep.simx_opmode_buffer);

% [returnCode, alfa] = vrep.simxGetObjectOrientation(clientID, end_effector_handle, vrep.simx_opmode_buffer);
% [returnCode, beta] = vrep.simxGetObjectOrientation(clientID, end_effector_handle, vrep.simx_opmode_buffer);
% [returnCode, gamma] = vrep.simxGetObjectOrientation(clientID, end_effector_handle, vrep.simx_opmode_buffer);

% [returnCode, rotation1] = vrep.simxGetJointPosition(clientID, driver_joint1_handle, vrep.simx_opmode_blocking);
% [returnCode, rotation2] = vrep.simxGetJointPosition(clientID, driver_joint2_handle, vrep.simx_opmode_blocking);
% [returnCode, rotation3] = vrep.simxGetJointPosition(clientID, driver_joint3_handle, vrep.simx_opmode_blocking);
% [returnCode, rotation4] = vrep.simxGetJointPosition(clientID, driver_joint4_handle, vrep.simx_opmode_blocking);
% [returnCode, rotation5] = vrep.simxGetJointPosition(clientID, driver_joint5_handle, vrep.simx_opmode_blocking);
% [returnCode, rotation6] = vrep.simxGetJointPosition(clientID, driver_joint6_handle, vrep.simx_opmode_blocking);

end