
function [xeed,yeed,zeed,xeedp,yeedp,zeedp]=circular_trajectory2(To,n,xc,yc,zc,L)
j=1;
k=2;    

zeed(j)= zc-L/2;               
yeed(j)= yc+L/2;            
xeed(j)= xc;

zeedp(j)= 0;               
yeedp(j)= 0;             
xeedp(j)= 0;

for j=2:length(n)
    
    if j<length(n)/4
    
    zeed(j)=zc-L/2+(L)*j/(length(n)/4);             
    yeed(j)=yc+L/2;                
    xeed(j)=xc; 
    
    zeedp(j)= (L)/(length(n)/4);               
    yeedp(j)= 0;               
    xeedp(j)= 0;
    end
    
    if j>length(n)/4 && j<length(n)/2
    
    zeed(j)=zc+L/2;             
    yeed(j)=yc+L/2-(L)*(j-length(n)/4)/(length(n)/4);                
    xeed(j)=xc; 
    
    zeedp(j)= 0;               
    yeedp(j)= -(L)/(length(n)/4);               
    xeedp(j)= 0;
    
    end
    
    if j>length(n)/2 && j<3*length(n)/4
    
    zeed(j)=zc+L/2-(L)*(j-2*length(n)/4)/(length(n)/4);             
    yeed(j)=yc-L/2;                
    xeed(j)=xc; 
    
    zeedp(j)= -(L)/(length(n)/4);               
    yeedp(j)= 0;               
    xeedp(j)= 0;
    
    end
    
    if j>3*length(n)/4 && j<length(n)
    
    zeed(j)=zc-L/2;             
    yeed(j)=yc-L/2+(L)*(j-3*length(n)/4)/(length(n)/4);                
    xeed(j)=xc; 
    
    zeedp(j)= 0;               
    yeedp(j)= (L)/(length(n)/4);               
    xeedp(j)= 0;
    
    end
    
end
end 


