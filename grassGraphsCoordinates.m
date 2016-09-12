% ggc = grassGraphsCoordinates(X, plotUVecs, p);
% This function returns the GrassGraphs coordinates of a 2D or 3D
% pointset. This means that given a pointset, you are provided with a 3D
% set of affine invariant coordinates regardless of whether the original
% points are 2D or 3D. The method is very sensitive to the epsilon values
% used to build the graphs, so if the LBO eigenvectors look collapsed or
% sparse play with different epsilon values. 2D responds much better to
% epsilon values than 3D. For 3D the epsilon values are very small usually
% 1e-4 to 1e-7 depending on the bounds of the pointset. 
%
% Play with different epsilong values to discover how the GG coordinates
% change. Remember this code is meant to be as simple and as straight
% forward as possible. This representation is very powerful and can be used
% as a foundation for some very effective non-rigid algorithms. In the
% grassGraphs matching function we show how the matching works with the
% simple nearest neighbor scheme and are able to resolve the sign flips to
% retrieve the correct correspondences. Note that the coordinates here will
% be off by sign flips so you may need to generate all 8 combinations of
% flips to do your own matching procedure.

%%%% ----- How to generate sign flips for 3D LBO coordinates --------%%%%%%

% % Resolving eigenvector flipping. 
% % Now we have to check which sign flip of the target shape eigenvectors
% % correponds to the closest of the eigenvectors of the source shape.
% % The extra -1 is because the number of eigenvectors chosen has the zero
% % vector contained in it so we remove it. The second -1 is to used to
% % generate the different permutations. This should genereate 8 different
% % combination of the three eigenvector flips.

% allPerms = dec2bin(2^(3) - 1: -1 : 0) - '0'; % All permutations.
% allPerms(allPerms == 0) = -1;   % Changing the zeros to -1s. 

% % The snippet of code above should generate a 8x3 matrix of 1's and -1's.
% % Each new flipped version of the LBO coordinates can be created by doing
% flipped_ggc = bsxfun(@times, ggc, allPerms(k,:));

% % The k in this case is just the kth row of the allperms matrix.
% -------------------------------------------------------------------------
% p = grassGraphsParams_Clean; % GrassGraphs parameters.
% plotUvecs = 1; 


function ggc = grassGraphsCoordinates(X, plotUVecs, p)

% Check if X is N x D. 
[numXRow, numXCol] = size(X);
if (numXRow < numXCol)
    X = X';
end

%% Flags.
plotLBO = 0;     % Display the LBO eigenvectors.
dispEigVals = 0; % Display the eigenvalues of the LBO representation.

%% Mean subtraction cases. 
UX = grassmannianRepresentationSingle(X);

%% Display U eigenvector output. 

% Plot U eigenvectors.
if (plotUVecs == 1)
    plot2D3DShapes_Single(X,p.UvecLegend,p.UvecTitle,p.UvecPos);
end

%% Graph Laplacian. 

% Form the epsilon-graph and its graph Laplacian.
LX = graphLaplacian_Clean(UX, p);

%% Eigendecomposition of the LBO.

try     % Error checking for eigenvector computation. 
    [ggc, XEvals] = eigenDecompositionLBO_Clean(LX,p);
catch
    % Increase the conditioning number. 
    prevCond = p.CondFac;
    p.CondFac = 1e5; 
    [ggc, XEvals] = eigenDecompositionLBO_Clean(LX,p);
    p.CondFac = prevCond; % Replace the value with the original. 
end

numEvecsUsed = numel(p.EvecToMatch);

% Display the eigenvalues of UX. 
XEvals = diag(XEvals);           % Pull the eigenvalues off the diagonal. 
XEvals(end) = [];                % Remove the smallest or zeroth eigenvalue. 
XEvals = flipud(XEvals);         % Put the eigenvalues in ascending order. 
XEvals = XEvals(1:numEvecsUsed); % Choose a subset of the eigenvectors. 

if (dispEigVals == 1)
    disp(['Eigenvalues of LBO of UX = ' num2str(XEvals')]);
end

% Plot the LBO shapes.
if (plotLBO == 1)
    plot2D3DShapes_Single(ggc,p.LBOLegend,p.LBOTitle, p.LBOPos);            
end
