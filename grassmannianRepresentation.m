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
function [UX, UY] = grassmannianRepresentation(X, Y)

% [UX, UY] = grassmannianRepresentation(X, Y)

% The number of points in X and Y are equal in this version of the
% GrassGraphs algorithm, so npX = npY.
[npX, nDim] = size(X); % Number of points in X.
[npY, nDim] = size(Y); % Number of points in X.

% Add homogeneous representation to X and Y.
hX = [X ones(npX,1)];
hY = [Y ones(npY,1)];

% Compute the svd of hX and hY. 
[UX, ~, ~] = svd(hX);
[UY, ~, ~] = svd(hY);

% Choose the first D+1 columns of U. 
UX = UX(:,1:nDim + 1);
UY = UY(:,1:nDim + 1);
