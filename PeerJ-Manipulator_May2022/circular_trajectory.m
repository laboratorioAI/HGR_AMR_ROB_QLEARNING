
function [xeed,yeed,zeed,xeedp,yeedp,zeedp]=circular_trajectory(To,n,xc,yc,zc,R)
j=1;
To=0.1;

xeed(j) = R*cos(j*2*pi/length(n))+xc;               
yeed(j) = R*sin(j*2*pi/length(n))+yc;           
zeed(j) = 0*sin(j*2*pi/length(n))+zc;  

for j=2:length(n)
    xeed(j) = R*cos(j*2*pi/length(n))+xc;               
    yeed(j) = R*sin(j*2*pi/length(n))+yc;           
    zeed(j) = 0*sin(j*2*pi/length(n))+zc;                
    xeedp(j) = 0;              
    yeedp(j) = 0;          
    zeedp(j) = 0;   
end 

end
