%--------------------------------------------------------------------------
% Function:    correspondenceDistance_Clean
% Description: This functions takes the eigenvectors of the LBO of the
%              source and target shape and computes the distance between
%              the points in that space, these distances are used to find
%              the correspondences for the original shapes. The distance
%              can be scaled to improve the spread on the points. 
% 
% Inputs: 
%
%   scrData     - Source data, set of eigenvectors of the LBO. 
%   
%   targData    - Target data, set of eigenvectors of the LBO. 
% 
%   p.scType    - Scaling type. No option returns the distance matrix from
%                 pdist2.
%                 Options are: maxScaling, logScaling, 'inverse',
%                 'exponential', noScale. 
%
%   p.scFac     - Scale factor. 
%   
% Outputs:
%
%   distMat     - Distance matrix, may or may not be scaled depending on 
%                 the option chosen.
% 
% Usage: Used in the affine invariance framework.
% -------------------------------------------------------------------------
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
function distMat = correspondenceDistance_Clean(srcData, targData, p)

% Distance matrix between the source and target shape.
distMat = pdist2(srcData, targData); % Distance matrix.

% figure; hist(distMat(:)); % Used to check the spread of the distances.

switch p.ScType
    
    case 'maxScaling'
        abDm = abs(distMat);
        maxAbsValDm = max(abDm(:));
        distMat = p.DistScFac*(distMat/maxAbsValDm);
  
    case 'noScale'
           
end 
