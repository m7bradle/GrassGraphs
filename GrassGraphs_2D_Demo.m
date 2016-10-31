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

% GrassGraphs 2D Affine Matching Algorithm. 
clear; clc; close all;

%% Add paths, parameters, flags.
addpath('.\Datasets\2D\');

plotOrigShape = 1;  % Plot the original shape. 
plotU = 1;      % Plot the U eigenvectors. 
plotRecShape = 1;   % Plot the recovered shape. 
p = grassGraphsParams_Clean; % GrassGraphs parameters.

%%  Load the shapes. 

shName = 'Gatorbait2nd50.mat'; 
load(shName);  % A cell name shapeCell is loaded. Each cell is a shape. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There are 50 shapes to choose from. The shape is chosen by using a number
% from 1 to 50. 
shNum = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = shapeCell{shNum}; % The shape is NxD. 

%% Apply the affine.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adjust the parameters of the affine transformation to see the effect of
% the recovery.

% Setup an affine transformation. 
theta = 0;      % Rotation angle 1. 
sigma = pi/2;   % Rotation angle 2.
a = 3;      % Scale in the x direction. 
b = 1;      % Scale in the y direction. 
tx = 0;     % Translation in x. 
ty = 0;     % Translation in y. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tVec = [tx, ty];
% Generate an affine transformation. 
A = affineTransformation2D_Clean(theta, sigma, tVec, a, b);

numShPoints = size(X,1); % Number of shape points. 
Xh = [X ones(size(X,1),1)]; % Homogeneous representation of X. 
Y = Xh*A; % Apply the affine to create Y. 
Y = Y(:,1:2);  % Keep only the first 2 dimensions. 

% --------------- Randomizing the correspondences.-------------------------
randVec = randperm(numShPoints); % Randomize the points. 
% Y = Y(randVec,:);
% -------------------------------------------------------------------------

if (plotOrigShape == 1) % Plot the original shapes
    plot2D3DShapes_Clean(X,Y, {'X','Y'}, 'Original Shapes');
end

%% Recover the affine and correspondences using the GrassGraphs algorithm.

[corr, rA] = grassGraphsMatching(X, Y, plotU, p);

recY = Xh*rA; % Form the recovered shape. 
recY = recY(:,1:2); % Remove the extra homogeneous dimension. 

% Norm between the recovered affine and the true affine. 
normAff = norm(rA - A, 'fro') ;

if (plotRecShape == 1)
    plot2D3DShapes_Clean(Y,recY,{'Y', 'Recovered Y'},...
        ['Norm of Affine = ' num2str(normAff)], 'south');
end

