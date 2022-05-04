
function [Uc,error]=LAC( Theta1, Theta2, Theta3, Theta4, Theta5, Theta6, xd1, yd1, zd1, xd, yd, zd, x, y, z, To, Rd1, Rd, Re)

K1=0.70;
K2=0.70;
K3=0.70;

K4=0.80;
K5=0.80;
K6=0.80;

%% Geometric parameters
l1=0.089;
l2=0.10;
l3=0.42;
l4=0.39;
l5=0.095;
l6=0.082;

%% Lineal velocity Jacobian submatrix
J11 =l5*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3))) + l6*(sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + cos(Theta1)*cos(Theta5)) + l2*cos(Theta1) - l4*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - l3*cos(Theta2 + pi/2)*sin(Theta1);
J12 =-cos(Theta1)*(l4*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + l3*sin(Theta2 + pi/2) + l5*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) + l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2))));
J13 =-cos(Theta1)*(l4*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + l5*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) + l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2))));
J14 =-cos(Theta1)*(l5*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) + l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2))));
J15 =l6*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)))*(sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + cos(Theta1)*cos(Theta5)) - l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)))*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)));
J16 =0;
J21 =l6*(sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1)) + l4*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + l2*sin(Theta1) - l5*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + l3*cos(Theta1)*cos(Theta2 + pi/2);
J22 =-sin(Theta1)*(l4*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + l3*sin(Theta2 + pi/2) + l5*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) + l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2))));
J23 =-sin(Theta1)*(l4*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + l5*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) + l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2))));
J24 =-sin(Theta1)*(l5*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3))) + l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2))));
J25 =l6*(cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)))*(sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1)) + l6*sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)))*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)));
J26 =0;
J31 =0;
J32 =cos(Theta1)*(l6*(sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1)) + l4*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - l5*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + l3*cos(Theta1)*cos(Theta2 + pi/2)) - sin(Theta1)*(l5*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3))) + l6*(sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + cos(Theta1)*cos(Theta5)) - l4*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - l3*cos(Theta2 + pi/2)*sin(Theta1));
J33 =cos(Theta1)*(l6*(sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1)) + l4*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + l2*sin(Theta1) - l5*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)))) - sin(Theta1)*(l5*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3))) + l6*(sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + cos(Theta1)*cos(Theta5)) + l2*cos(Theta1) - l4*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)));
J34 =cos(Theta1)*(l6*(sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1)) - l5*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)))) - sin(Theta1)*(l5*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3))) + l6*(sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + cos(Theta1)*cos(Theta5)));
J35 =l6*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)))*(sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) + cos(Theta1)*cos(Theta5)) + l6*(sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) + cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)))*(sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1));
J36 =0;
%% Angular velocity Jacobian submatrix
J41 =0;
J42 =sin(Theta1);
J43 =sin(Theta1);
J44 =sin(Theta1);
J45 =- cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2));
J46 =sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*cos(Theta2 + pi/2) - cos(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta1)*cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta1)*cos(Theta2 + pi/2)*sin(Theta3))) + cos(Theta5)*sin(Theta1);
J51 =0;
J52 =-cos(Theta1);
J53 =-cos(Theta1);
J54 =-cos(Theta1);
J55 =- sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2)) - cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3));
J56 =- sin(Theta5)*(sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta1)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta1)*sin(Theta3)) - cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2)*sin(Theta1) - sin(Theta1)*sin(Theta3)*sin(Theta2 + pi/2))) - cos(Theta1)*cos(Theta5);
J61 =1;
J62 =0;
J63 =0;
J64 =0;
J65 =cos(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)) - sin(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3));
J66 =sin(Theta5)*(cos(Theta4 - pi/2)*(cos(Theta3)*sin(Theta2 + pi/2) + cos(Theta2 + pi/2)*sin(Theta3)) + sin(Theta4 - pi/2)*(cos(Theta3)*cos(Theta2 + pi/2) - sin(Theta3)*sin(Theta2 + pi/2)));

%% Analytical Jacobian Matrix
J = [J11 J12 J13 J14 J15 J16; J21 J22 J23 J24 J25 J26; J31 J32 J33 J34 J35 J36; J41 J42 J43 J44 J45 J46 ;J51 J52 J53 J54 J55 J56; J61 J62 J63 J64 J65 J66];

eul = rotm2eul(Re,"ZYX");

gxa=eul(1);
gya=eul(2);
gza=eul(3);

A=[1 0 sin(gya);0 cos(gxa) -sin(gxa)*cos(gya);0 sin(gxa) cos(gya)];

Ainv=inv(A);
I=[1,0,0;0,1,0;0,0,1];
O=[0,0,0;0,0,0;0,0,0];
M=[I,O;O,Ainv];
Ja=M*J;

%% Orientation error
R1=Rd*Re';
eo1=1/2*[R1(3,2)-R1(2,3);R1(1,3)-R1(3,1);R1(2,1)-R1(1,2)];

R2=Rd1*Re';
eo2=1/2*[R2(3,2)-R1(2,3);R2(1,3)-R1(3,1);R2(2,1)-R1(1,2)];

ephix = eo1(1);
ephiy = eo1(2);
ephiz = eo1(3);

ephi2x = eo2(1);
ephi2y = eo2(2);
ephi2z = eo2(3);

ex=xd-x;
ey=yd-y;
ez=zd-z;
    
Xc = [xd1-K1*ex-x;...
      yd1-K2*ey-y;...
      zd1-K3*ez-z;...
      ephi2x-K4*ephix;...
      ephi2y-K5*ephiy;...
      ephi2z-K6*ephiz];

k=[1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1];

Uc = inv(Ja)*k*Xc/To;

error = [ex;ey;ez;ephix;ephiy;ephiz];
end