%--------------------------------------------------------------------------
% Function:    affineTransformation3D_V2
% Description: This function takes in 2 sets of angles, three scaling parameters and a 
%              translation vector and outputs an affine transformation. The 
%              transformation is composed of a rotation,scale, rotation and
%              then translation. 
% 
% Inputs: 
%
%   theta       - Angle for left rotation matrix.
%
%   sigma       - Angle for right rotation matrix. 
%
%   tVec        - Translation vector [tx ty]. 
% 
%   sc          - Scaling parameters [a,b,c].
%   
% Outputs:
%
%   A           - Affine transformation. 
% 
% Usage: Used in the affine invariance framework.
%
% {GrassGraph Algorithm, used to perform affine invariant feature matching.}
%     Copyright (C) {2016}  {Mark Moyou}
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%   
%     mmoyou@my.fit.edu
%     Information Characterization and Exploitation (ICE) Lab
% -------------------------------------------------------------------------
function A = affineTransformation3D_Clean(thetas, sigmas, tVec, sc)

thetax = thetas(1);
thetay = thetas(2);
thetaz = thetas(3);

sigmax = sigmas(1);
sigmay = sigmas(2);
sigmaz = sigmas(3);

a = sc(1);
b = sc(2); 
c = sc(3);

% Form the left rotation matrix. 
R1x = [1, 0, 0;...
       0, cos(thetax), -sin(thetax);...
       0, sin(thetax), cos(thetax)];
   
R1y = [cos(thetay), 0, sin(thetay);...
       0,1, 0;...
       -sin(thetay), 0, cos(thetay)];
      
R1z = [cos(thetaz), -sin(thetaz), 0;...
       sin(thetaz), cos(thetaz), 0;...
       0, 0, 1];

R1 = R1z*R1y*R1x;

aMat = diag([2^a, 2^b, 2^c]);

% Form the left rotation matrix. 
R2x = [1, 0, 0;...
       0, cos(sigmax), -sin(sigmax);...
       0, sin(sigmax), cos(sigmax)];
   
R2y = [cos(sigmay), 0, sin(sigmay);...
       0, 1, 0;...
       -sin(sigmay), 0, cos(sigmay)];
      
R2z = [cos(sigmaz), -sin(sigmaz), 0;...
       sin(sigmaz), cos(sigmaz), 0;...
       0, 0, 1];

R2 = R2x*R2y*R2z;

% Form the composition of the rotation and scale matrices. 
R = R1*aMat*R2; % Rotation, scale, rotation. 

A = zeros(4);
A(1:3,1:3) = R;
A(4,1:3) = tVec;
A(4,4) = 1;


  

