
%% UR5Control.m

close all;
clc;
%% CoppeliaSim connection
vrep=remApi('remoteApi');
vrep.simxFinish(-1);

clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);

if (clientID > -1)
    disp('Connected to remote API server');  
else        
    disp('Failed connecting to remote API server');
    close;
end

vrep.simxSynchronous(clientID, true); %Set-up synchronous communication on
vrep.simxStartSimulation(clientID, vrep.simx_opmode_blocking); % Start

%% Robot nodes

%%Joints
[returnCode,art_1]=vrep.simxGetObjectHandle(clientID,'UR5_joint1',vrep.simx_opmode_blocking);
[returnCode,art_2]=vrep.simxGetObjectHandle(clientID,'UR5_joint2',vrep.simx_opmode_blocking);
[returnCode,art_3]=vrep.simxGetObjectHandle(clientID,'UR5_joint3',vrep.simx_opmode_blocking);
[returnCode,art_4]=vrep.simxGetObjectHandle(clientID,'UR5_joint4',vrep.simx_opmode_blocking);
[returnCode,art_5]=vrep.simxGetObjectHandle(clientID,'UR5_joint5',vrep.simx_opmode_blocking);
[returnCode,art_6]=vrep.simxGetObjectHandle(clientID,'UR5_joint6',vrep.simx_opmode_blocking);
%%End-Effector UR5
[returnCode,TIP]=vrep.simxGetObjectHandle(clientID,'UR5_connection',vrep.simx_opmode_blocking);
%%Reference System
[returnCode,Reference]=vrep.simxGetObjectHandle(clientID,'ResizableFloor_5_25',vrep.simx_opmode_blocking);
[returnCode, tip_pos] = vrep.simxGetObjectPosition(clientID, TIP, -1, vrep.simx_opmode_streaming);
[returnCode, rotation1] = vrep.simxGetJointPosition(clientID, art_1, vrep.simx_opmode_streaming);
[returnCode, rotation2] = vrep.simxGetJointPosition(clientID, art_2, vrep.simx_opmode_streaming);
[returnCode, rotation3] = vrep.simxGetJointPosition(clientID, art_3, vrep.simx_opmode_streaming);
[returnCode, rotation4] = vrep.simxGetJointPosition(clientID, art_4, vrep.simx_opmode_streaming);
[returnCode, rotation5] = vrep.simxGetJointPosition(clientID, art_5, vrep.simx_opmode_streaming);
[returnCode, rotation6] = vrep.simxGetJointPosition(clientID, art_6, vrep.simx_opmode_streaming);
%%Paint Nozzle
[returnCode,paint]= vrep.simxGetObjectHandle(clientID, 'PaintNozzle', vrep.simx_opmode_blocking);

%% Connection Stablished Notice
vrep.simxAddStatusbarMessage(clientID,'Comunicación con MATLAB iniciada',vrep.simx_opmode_blocking);
disp('Comunicacion con V-REP Iniciada'); 
Escribir(vrep, clientID, art_1, art_2, art_3, art_4, art_5, art_6, 0, 0, 0, 0, 0, 0);

%% Simulation Settings:
T = 50; % Simulation Time in Seconds

%% Simulation Loop
To=0.1;      %Sample Time 100ms
n=0:To:T;  %Auxiliar vector

%% Time vector
ts=0.1; % sample time
t=0:ts:T; % vector time

%% Controller
control=1; %% (Control 1-PID, 2-LAC) 

if control == 1
error1 = [ ];
pos1 = [ ];
ref1 = [ ];
orien1 = [ ];
oref1 = [ ];

else
    
error2 = [ ];
pos2 = [ ];
ref2 = [ ];
orien2 = [ ];
oref2 = [ ];
end

%%Aux variables
Pistola=0;
Jacobiana=[ ];
CoppeliaSim=[ ];
posm =[ ];
ea=zeros(6,length(t));
Sum=0;

orientation=1;
aux=0;
aux1=0;
aux2=0;
aux3=0;
aux4=0;
HGR=0;
contador=1;
gesture=0;

auxgesture1=0;
auxgesture2=0;
auxgesture3=0;
auxgesture4=0;

oldk1=1;
oldk2=1;
oldk3=1;
oldk4=1;

c=1;

%% Predefined 2D trajectories
R=0.1;
%%Square path center in y-z plane
xc=0.40;  
yc=0;
zc=0.80;

L=0.15;
R=0.15;

%[xeed,yeed,zeed,xrdp,yrdp,zrdp]=circular_trajectory_O1(T,n,xc,yc,zc,R);
[xeed,yeed,zeed,xrdp,yrdp,zrdp]=square_trajectory(T,n,xc,yc,zc,L);

xee = zeros(1,length(xeed));
zee = zeros(1,length(xeed));
yee = zeros(1,length(xeed));

%% Desired positions and orientations (TEST)
% hxd=0.4850;
% hyd=-0.10;
% hzd=0.9836;

% hxd=0.45;
% hyd=0.45;
% hzd=0.7;

% hxd1=0.4850;
% hyd1=-0.10;
% hzd1=0.9836;

%% Myo Armband Data (IMU) (Only for HGR+IMU mode)

mm=MyoMex;              
pause(1);   
m1 = mm.myoData;
q=m1.quat;
euler0 = quat2eul(q);

%% TCP/IP Server (Only for HGR+IMU mode)

server = tcpserver("0.0.0.0",30000);  % TCP/IP Server

%% Communication Test

for k=1:1:20
    [q1, q2, q3, q4, q5, q6, posicion] = Leer(vrep, clientID,art_1, art_2, art_3, art_4, art_5, art_6, TIP);
    [q1,q2,q3,q4,q5,q6]=wrapToArm(q1,q2,q3,q4,q5,q6);
end

[R,xm,ym,zm,y,p,r]=MCD(q1, q2, q3, q4, q5, q6);

%% Actual position and orientation end-effector reference

hxd=xm;
hyd=ym;
hzd=zm;

hxd1=xm;
hyd1=ym;
hzd1=zm;

hxpd=0;
hypd=0;
hzpd=0;

Rd=[0,0,1;1,0,0;0,1,0]; % X axis (+)
Rd1=[0,0,1;1,0,0;0,1,0]; % X axis (+)

% Rd=[0,-1,0;-1,0,0;0,0,-1]; % Z axis (-)               
% Rd1=[0,-1,0;-1,0,0;0,0,-1]; % Z axis (-)

% Rd=[1,0,0;0,0,-1;0,1,0]; % Y axis (-)
% Rd1=[1,0,0;0,0,-1;0,1,0]; % Y axis (-)

%% Aux trajectory generation (Only for trajectory tracking mode)

samples=150;
wpts = [0.4850 xeed(1);-0.10 yeed(1);0.9836 zeed(1)];
[at, atd, qdd, tvec, pp] = trapveltraj(wpts, samples,'PeakVelocity',0.02);

%% Operating Modes (Trajectory Tracking=1, HGR+IMU=2, Position Control=3)

modo=2;

for k=2:length(t)+length(at)-3
    
    tic;
    
%% Modes
%% Trajectories generated in Matlab
if modo==1
    if k<length(at)
    hxd=at(1,k);
    hyd=at(2,k);
    hzd=at(3,k);

    hxd1=at(1,k+1);
    hyd1=at(2,k+1);
    hzd1=at(3,k+1);

    hxpd=atd(1,k);
    hypd=atd(2,k);
    hzpd=atd(3,k);

    elseif k>length(at) && k<length(at)+length(t)

    hxd=xeed(k-samples+1);
    hyd=yeed(k-samples+1);
    hzd=zeed(k-samples+1);

    hxd1=xeed(k-samples+2);
    hyd1=yeed(k-samples+2);
    hzd1=zeed(k-samples+2);

    hxpd=xrdp(k-samples+1);
    hypd=yrdp(k-samples+1);
    hzpd=zrdp(k-samples+1);
    end

    if k==3
        vrep.simxCallScriptFunction(clientID, 'PaintNozzle', vrep.sim_scripttype_childscript, 'Apagado', [], [], [], 0, vrep.simx_opmode_blocking)
    end

    if k==samples
        vrep.simxCallScriptFunction(clientID, 'PaintNozzle', vrep.sim_scripttype_childscript, 'Encendido', [], [], [], 0, vrep.simx_opmode_blocking)
    end

%% Trajectories generated by the HMI
elseif modo==2
    %%Euler Angles (Selection commands)
    q=m1.quat;
    euler = quat2eul(q)-euler0;
    euler = round(euler,4);
    
    %%(Movement Commands: Euler angles of Myo Armband's IMU)
    
    if euler(1)>0.40
        %disp('Left')
        hyd=ym+c*0.01;
        hyd1=ym+c*0.01;
    elseif euler(1)<-0.40
        %disp('Right');
        hyd=ym-c*0.02;
        hyd1=ym-c*0.02;
    else
    end

    if euler(2)>0.40
        %disp('Up');
        hzd=zm+c*0.01;
        hzd1=zm+c*0.01;
    elseif euler(2)<-0.40
        %disp('Down');
        hzd=zm-c*0.01;
        hzd1=zm-c*0.01;
    else
    end

    if euler(3)>0.40
        %disp('Forward');
        hxd=xm+c*0.01;
        hxd1=xm+c*0.01;
    elseif euler(3)<-0.4
        %disp('Backward');
        hxd=xm-c*0.01;
        hxd1=xm-c*0.01;
    else
    end
    
    %% Gesture adquisition (Selection commands)
    
    if server.NumBytesAvailable>0
    gesture = read(server,server.NumBytesAvailable,'uint8');
    flush(server);
    end
    
    %%(Selecion Command: Fist gesture)
    if gesture==3 
        pistola=1;
        vrep.simxCallScriptFunction(clientID, 'PaintNozzle', vrep.sim_scripttype_childscript, 'Encendido', [], [], [], 0, vrep.simx_opmode_blocking);
    else
        pistola=0;
        vrep.simxCallScriptFunction(clientID, 'PaintNozzle', vrep.sim_scripttype_childscript, 'Apagado', [], [], [], 0, vrep.simx_opmode_blocking);
    end
    
    %%(Selecion Command: Open gesture)    
    if gesture==4
        if k-oldk3==1              
            auxgesture3=auxgesture3+1;
        else
            auxgesture3=0; 
        end

        if auxgesture3>=50
            if c==1
                c=2;
            else
                c=1;
            end
        auxgesture3=0;
        end
            
        oldk3=k;
    else

    end

    %%Orientation Selection
    %%(Selecion Command: Wave in and Wave out gestures) 
    if gesture==1
        if orientation<3
            if k-oldk1==1              
            auxgesture1=auxgesture1+1;
            else
            auxgesture1=0; 
            end

            if auxgesture1>=30
            orientation=orientation+1
            beep;
            auxgesture1=0;
            end

            oldk1=k;
        end
    else

    end


    if gesture==2
        if orientation>1

            if k-oldk2==1              
            auxgesture2=auxgesture2+1;
            else
            auxgesture2=0; 
            end

            if auxgesture2>=30
            orientation=orientation-1
            beep;
            auxgesture2=0;
            end

            oldk2=k;
        end
    else

    end

   %%(Selecion Command: Pinch gesture) 
   if aux2==0
       if gesture==5
           switch orientation
           case 1  
               Rd=[0,-1,0;-1,0,0;0,0,-1]; % Axis Z (-)
               Rd1=[0,-1,0;-1,0,0;0,0,-1]; % Axis Z (-)
           case 2
               Rd=[0,0,1;1,0,0;0,1,0]; % Axis X (+)                                                      
               Rd1=[0,0,1;1,0,0;0,1,0]; % Axis X (+)
           case 3 
               Rd=[1,0,0;0,0,-1;0,1,0]; % Axis Y (+)                   
               Rd1=[1,0,0;0,0,-1;0,1,0]; % Axis Y (+)
           
           end
           aux2=1;
          beep;
       end
   else
       aux2=aux2+1;
       if aux2>=20
           aux2=0;
       end
   end
       
else
%% Position control Mode
    
    % Position reference
    hxd=0.20;
    hyd=0.20;
    hzd=1.0;

    hxd1=0.20;
    hyd1=0.20;
    hzd1=1.0;

    hxpd=0;
    hypd=0;
    hzpd=0;

end
%% Read information from UR5

    [q1, q2, q3, q4, q5, q6, posicion] = Leer(vrep, clientID, art_1, art_2, art_3, art_4, art_5, art_6, TIP); % Red information from UR5 Virtual Model
    [q1,q2,q3,q4,q5,q6]=wrapToArm(q1,q2,q3,q4,q5,q6);   % Adjutst angle 
    [R,xm,ym,zm,y,p,r]=MCD(q1, q2, q3, q4, q5, q6);  %% Kinematic Model
    posm = [posm;xm,ym,zm];   %% Results from kinematic model

%% Controllers

    if control == 1
    To=0.1;
    [Uc,e]=PIDq(q1, q2, q3, q4, q5, q6, xm, ym, zm, hxd, hyd, hzd, hxpd, hypd, hzpd,R,Rd); 
    else
    To=0.1;
    [Uc,e]=LAC(q1, q2, q3, q4, q5, q6, hxd1, hyd1, hzd1, hxd, hyd, hzd, xm, ym, zm, To, Rd1, Rd, R);
    end
    
%%  Write control actions to UR5
    Escribir(vrep, clientID, art_1, art_2, art_3, art_4, art_5, art_6, Uc(1), Uc(2), Uc(3), Uc(4), Uc(5), Uc(6));

%%  Data collection
    if control == 1
    error1 = [error1,e];
    pos1 = [pos1;xm,ym,zm];  
    ref1 = [ref1;hxd,hyd,hzd];
    orien1 = [orien1;y,p,r];
    Eulerd = rotm2eul(Rd,'xyz');
    oref1 = [oref1;Eulerd(1),Eulerd(2),Eulerd(3)];
    
    else
    error2 = [error2,e];
    pos2 = [pos2;xm,ym,zm];  
    ref2 = [ref2;hxd,hyd,hzd];
    orien2 = [orien2;y,p,r];
    Eulerd = rotm2eul(Rd,'xyz');
    oref2 = [oref2;Eulerd(1),Eulerd(2),Eulerd(3)];
    end
   
    dt=toc;
%% ISE and MSE
    ea(:,k+1) = ea(:,k) + dt*abs(e);
    Sum=Sum+e.^2;
end

%% IAE and MSE computation
area=ea(:,length(t)-1);
ISE=sqrt(area(1)^2+area(2)^2+area(3)^2+area(4)^2+area(5)^2+area(6)^2)

L=k;
Sum=Sum/L;
MSE=sqrt(Sum(1)^2+Sum(2)^2+Sum(3)^2+Sum(4)^2+Sum(5)^2+Sum(6)^2)

%% Stop Myo Armband's connection
mm.delete;
clear mm;

%% Stop communication with CoppeliaSim
Escribir(vrep, clientID, art_1, art_2, art_3, art_4, art_5, art_6, 0, 0, 0, 0, 0, 0);

vrep.simxAddStatusbarMessage(clientID,'Comunicación Finalizada',vrep.simx_opmode_blocking);
vrep.simxStopSimulation(clientID, vrep.simx_opmode_oneshot_wait);
vrep.simxFinish(clientID);
vrep.delete();
vrep.simxFinish(clientID);
disp('Comunicacion con V-REP Finalizada');
