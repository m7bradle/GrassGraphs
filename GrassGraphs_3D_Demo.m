% GrassGraphs 2D Affine Matching Algorithm. 
clear; clc; close all;

%% Add paths, parameters, flags.
addpath('.\Datasets\3D\');

plotOrigShape = 1;  % Plot the original shape. 
plotU = 1;      % Plot the U eigenvectors. 
plotRecShape = 1;   % Plot the recovered shape. 
p = grassGraphsParams_Clean; % GrassGraphs parameters.

%%  Load the shapes. 

shName = 'COSEG'; 
load(shName);  % A cell name shapeCell is loaded. Each cell is a shape. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There are 50 shapes to choose from. The shape is chosen by using a number
% from 1 to 50. 
shNum = 40;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = shapeCell{shNum}; % The shape is NxD. 

%% Apply the affine.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adjust the parameters of the affine transformation to see the effect of
% the recovery. Note there must be three angles in thetas and sigmas each. 

% Setup an affine transformation. 
thetas = [0, 0, pi/8]; % Three angles of rotation in x,y,z.
sigmas = [0, -pi/8, pi/6]; % Three angles of rotation in x,y,z.
a = 2;          % Scale in x. 
b = 0.5;        % Scale in y. 
c = -1;         % Scale in z.
tx = 0;         % Translation in x.
ty = 0;         % Translation in y. 
tz = 0;         % Translation in z.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sc = [a, b, c];         % Scaling vector. 
tVec = [tx, ty, tz];    % Translation vector. 

% Generate an affine transformation. 
A = affineTransformation3D_Clean(thetas, sigmas, tVec, sc);

numShPoints = size(X,1); % Number of shape points. 
Xh = [X ones(size(X,1),1)]; % Homogeneous representation of X. 
Y = Xh*A; % Apply the affine to create Y. 
Y = Y(:,1:3);  % Keep only the first 3 dimensions. 

% --------------- Randomizing the correspondences.-------------------------
randVec = randperm(numShPoints); % Randomize the points. 
Y = Y(randVec,:);
% -------------------------------------------------------------------------

if (plotOrigShape == 1) % Plot the original shapes
    plot2D3DShapes_Clean(X,Y, {'X','Y'}, 'Original Shapes');
end

%% Recover the affine and correspondences using the GrassGraphs algorithm.

[corr, rA] = grassGraphsMatching(X, Y, plotU, p);

recY = Xh*rA; % Form the recovered shape. 
recY = recY(:,1:3); % Remove the extra homogeneous dimension. 

% Norm between the recovered affine and the true affine. 
normAff = norm(rA - A, 'fro') ;

if (plotRecShape == 1)
    plot2D3DShapes_Clean(Y,recY,{'Y', 'RecY'},...
        ['Norm of Affine = ' num2str(normAff)], 'south');
end

