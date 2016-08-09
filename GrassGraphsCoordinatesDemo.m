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
Y = Y(randVec,:);
% -------------------------------------------------------------------------

if (plotOrigShape == 1) % Plot the original shapes
    plot2D3DShapes_Clean(X,Y, {'X','Y'}, 'Original Shapes');
end

%% Get the GrassGraph coordinates of the shape.

% Plotting information for Y.
p.UvecTitle = 'U Eigenvector Representation'; p.UvecLegend = 'X';
p.UvecPos = 'east';
p.LBOTitle = 'GG Representation'; p.LBOLegend = 'X'; 
p.LBOPos = 'southwest';

% Grass Graph coordinates X.
ggcX = grassGraphsCoordinates(X,  plotU, p);

% Plotting information for Y.
p.UvecTitle = 'U Eigenvector Representation';  p.UvecLegend = 'Y';
p.UvecPos = 'west';
p.LBOTitle = 'GG Representation'; p.LBOLegend = 'Y';
p.LBOPos = 'southeast';

% Grass Graph coordinates. 
ggcY = grassGraphsCoordinates(Y,  plotU, p);

if (plotRecShape == 1)
    plot2D3DShapes_Clean(ggcX,ggcY,{'ggX', 'ggY'},...
        'GrassGraph coordinates', 'south');
end

