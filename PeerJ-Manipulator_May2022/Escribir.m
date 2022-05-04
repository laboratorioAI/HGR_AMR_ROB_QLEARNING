function Escribir(sim, clientID,qp1,qp2,qp3,qp4,qp5,qp6,speed_q1,speed_q2,speed_q3,speed_q4,speed_q5,speed_q6)    

    sim.simxSetJointTargetVelocity(clientID, qp1, speed_q1,sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, qp2, speed_q2,sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, qp3, speed_q3,sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, qp4, speed_q4,sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, qp5, speed_q5,sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, qp6, speed_q6,sim.simx_opmode_oneshot);

    % Synchronous Trigger to read the values from VREP:
    % Synchronous Trigger to update simulation time by dt (dt = 5ms)
    sim.simxSynchronousTrigger(clientID);
    % Check to wait till the computations on VREP are completed
    sim.simxGetPingTime(clientID); 
end

