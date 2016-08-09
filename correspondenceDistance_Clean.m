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
