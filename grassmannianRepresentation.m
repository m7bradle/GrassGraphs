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