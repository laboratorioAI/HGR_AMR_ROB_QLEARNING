%% Connection for MATLAB/VREP in synchronous mode
% 3D printing - 2017
% Copyright (c), Robert Guamán, Universidad Técnica Federico Santa María,
% 2020
% PhD(c) studdent
function [rotation1,rotation2,rotation3,rotation4,rotation5,rotation6]=wrapToArm(rotation1,rotation2,rotation3,rotation4,rotation5,rotation6)

rotation1 = wrapToPi(rotation1);
rotation2 = wrapToPi(rotation2);
rotation3 = wrapToPi(rotation3);
rotation4 = wrapToPi(rotation4);
rotation5 = wrapToPi(rotation5);
rotation6 = wrapToPi(rotation6);
