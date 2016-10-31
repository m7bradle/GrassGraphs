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
function rA = recoveredAffine_Clean(cX, cY)

% Recover the affine transformation. 
numCorr = size(cX,1); % Number of correspondences.
cX = [cX ones(numCorr,1)];
cY = [cY ones(numCorr,1)];
rA = ((cX'*cX)^-1)*cX'*cY;
