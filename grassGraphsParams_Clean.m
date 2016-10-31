%--------------------------------------------------------------------------
% Function:    grassGraphsParams_Clean
% Description: This function stores the parameters needed to run the 2D
%              affine experiments for the ICCV 2015 submission. This
%              assumes that the source and target shape have already been
%              generated separately. 
% 
% Outputs:
%
%   p.epsilon        - Epsilon value for building the graph Laplacian on
%                      the U eigenvectors (U comes from the SVD of the 
%                      homogeneous representation of the points).
%
%   p.CorrMethod     - Correpondence method. Minimum Euclidean distance is
%                      the only option available in this version of the
%                      code. = 'minDistThrowOut'. This correspondence
%                      method throws out values that have multple target
%                      points assigned to a source point. .
%
%   p.CondFac        - Conditioning factor for the Laplacian matrix. This
%                      number is multiplied by eps to condition the
%                      diagonal of the Laplacian matrix for eigenvalue
%                      decomposition. 
%   
%   p.GraphLapType   - Flag for the type of graph to construct. 
%                     'eucDist' - Euclidean distances as the weights. 
%                     'heatKer' - Heat kernel weights. 
%                     'connect' - Just the connectivity graph using the
%                                 adjacency matrix. 
%   
%   p.numLBOEvec     - Number of LBO eigenvectors to compute. This includes
%                      the zeroth eigenvector. 
% 
%   p.EvecToMatch    - The eigenvectors used to match the shapes. This
%                      excludes the zeroth eigenvector correponding to the
%                      smallest eigenvalue. 
%                      If the number of elements exceeds
%                      this then elements will be removed from the vector
%                      until the maximum number of elements allowed is
%                      achieved.
%                      e.g. eigVecsToMatch = [1 2 3];
% 
%   p.ScaleDistFac   - Factor used to scale the distance between the LBO
%                      eigenvector representation of the shape. 
% 
%   p.ScaleDist      - Factor that scales the distance. 
% 
%   p.NormUVecs      - Normalize U eigenvectors (1-on).
%
%   p.hkt            - Hear kernel parameter t. 
% 
%   p.ScalingType    - Scaling type for the distance matrix between the
%                      chosen LBO eigenvectors. 
%
%   p.allPerms       - All the permutations of 1's and -1's that are used
%                      to solve the eigenvector permutation.
%                      eg. [1 1 1; 1 -1 1]. A row is a single permutation.
%                      The column entry in each row multiplies the
%                      corresponding column of the eigenvector matrix.
%
%   p.numPerms       - Number of permutation.
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
 function p = grassGraphsParams_Clean

% -------------------- Flags & Variables ----------------------------------

p.fhkt = 100;                   % For the full graph case, not used. 
p.Epsilon = 0.012;              % Epsilon value. 
p.hkt = 175;                    % Heat kernel value.
p.GraphCase = 'epsilon';
p.GraphLapType = 'heatKer';

p.CorrMethod = 'minDistThrowOut';
p.CondFac = 500;        
p.GraphLapType = 'heatKer';
p.NumLBOEvec = 5;               % Number of eigenvectors to compute. 

p.EvecToMatch = [1, 2, 3];      % Eigenvectors used to match in the LBO space.

p.DistScFac = 1e-4; 

p.ScaleDist = 0; % May not be used. 

p.ScType = 'maxScaling'; % Scaling type for distance matrix.

% Resolving eigenvector flipping. 
% Now we have to check which sign flip of the target shape eigenvectors
% correponds to the closest of the eigenvectors of the source shape.
% The extra -1 is because the number of eigenvectors chosen has the zero
% vector contained in it so we remove it. The second -1 is to used to
% generate the different permutations. This should genereate 8 different
% combination of the three eigenvector flips.
numEigVecForPerm = numel(p.EvecToMatch);
p.AllPerms = dec2bin(2^(numEigVecForPerm) - 1: -1 : 0) - '0'; % All permutations.
p.AllPerms(p.AllPerms == 0) = -1;   % Changing the zeros to -1s. 
p.NumPerms = size(p.AllPerms,1);    % Number of permutations. 

p.eigSc = 0;        % Scale the eigenvectors with the eigenvalues.

p.CorrThresh = 3;

p.ScoreType = 'NumCorr';
