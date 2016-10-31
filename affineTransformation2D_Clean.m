%--------------------------------------------------------------------------
% Function:    affineTransformation2D_Clean
% Description: This function takes in 2 angles, a scaling parameter and a 
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
%   a           - Scaling parameter.
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
% ------------------------------------------------------------------------------
% -------------------------------------------------------------------------
function A = affineTransformation2D_Clean(theta, sigma, tVec, a, b)

% Form the left rotation matrix. 
R1 = [cos(theta) -sin(theta);...
      sin(theta) cos(theta)];

% Form the scaling matrix. 
aMat = diag([2^a, 2^b]);

% Form the right rotation matrix. 
R2 = [cos(sigma) -sin(sigma);...
      sin(sigma) cos(sigma)];

% Form the composition of the rotation and scale matrices. 
R = R1*aMat*R2; % Rotation, scale, rotation. 

A = zeros(3);
A(1:2,1:2) = R;
A(3,1:2) = tVec;
A(3,3) = 1;


  

