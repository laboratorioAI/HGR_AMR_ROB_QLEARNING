
function [R,xm,ym,zm,yaw,pitch,roll]=MCD(Theta1, Theta2, Theta3, Theta4, Theta5, Theta6)

%% Con Theta6

l1=0.089;
l2=0.10;
l3=0.42;
l4=0.39;
l5=0.095;
l6=0.082;

R11 =cos(Theta6)*(cos(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) - sin(Theta1)*sin(Theta5)) - sin(Theta6)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)));
R12 =- cos(Theta6)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) - sin(Theta6)*(cos(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) - sin(Theta1)*sin(Theta5));
R13 =sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1);

R21 =- sin(Theta6)*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3))) - cos(Theta6)*(cos(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) - cos(Theta1)*sin(Theta5));
R22 =sin(Theta6)*(cos(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) - cos(Theta1)*sin(Theta5)) - cos(Theta6)*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)));
R23 =- sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) - cos(Theta1)*cos(Theta5);

R31 =sin(Theta6)*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*cos(Theta6)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)));
R32 = cos(Theta6)*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) - cos(Theta5)*sin(Theta6)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)));
R33 = sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)));

%% con T06 calculada directamente (Sin la matriz T67)
zm =l1 + l4*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + l3*sin(Theta2 + pi/2) + l5*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) + l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)));
ym =l4*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - l6*(sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + cos(Theta1)*cos(Theta5)) - l2*cos(Theta1) - l5*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3))) + l3*cos(Theta2 + pi/2)*sin(Theta1);
xm =l6*(sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1)) + l4*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + l2*sin(Theta1) - l5*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + l3*cos(Theta1)*cos(Theta2 + pi/2);

%% con T07
% xm =l6*(sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1)) + l4*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + l2*sin(Theta1) - l5*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + l3*cos(Theta1)*cos(Theta2 + pi/2);
% ym =l4*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - l6*(sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + cos(Theta1)*cos(Theta5)) - l2*cos(Theta1) - l5*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3))) + l3*cos(Theta2 + pi/2)*sin(Theta1);
% zm =l1 + l4*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + l3*sin(Theta2 + pi/2) + l5*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) + l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)));

%%
zm=zm+0.5566;
R=[R11,R12,R13;R21,R22,R23;R31,R32,R33];

%% Sin Theta 6

% l1=0.089;
% l2=0.10;
% l3=0.42;
% l4=0.39;
% l5=0.095;
% l6=0.082;
% 
% R11 =cos(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) - sin(Theta1)*sin(Theta5);
% R12 =- cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2));
% R13 =sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1);
% R21 =cos(Theta1)*sin(Theta5) - cos(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)));
% R22 =- sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3));
% R23 =- sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) - cos(Theta1)*cos(Theta5);
% R31 =cos(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)));
% R32 =cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3));
% R33 =sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)));
%  
% xm =l6*(sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1)) + l4*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + l2*sin(Theta1) - l5*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + l3*cos(Theta1)*cos(Theta2 + pi/2);
% ym =l4*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - l6*(sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + cos(Theta1)*cos(Theta5)) - l2*cos(Theta1) - l5*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3))) + l3*cos(Theta2 + pi/2)*sin(Theta1);
% zm =l1 + l4*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + l3*sin(Theta2 + pi/2) + l5*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) + l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)));
% 
% zm=zm+0.5566;
% 
% R=[R11,R12,R13;R21,R22,R23;R31,R32,R33];
% yaw=atan2(R(2,1),R(1,1));
% pitch=atan2(-R(3,1),sqrt(R(3,2)^2+R(3,3)^2));
% roll=atan2(R(3,2),R(3,3));
Euler = rotm2eul(R,'ZYX');
yaw=Euler(3);
pitch=Euler(2);
roll=Euler(1);

end