%--------------------------------------------------------------------------
% Function:    graphLaplacian_Clean
% Description: This function constructs an epsilon graph for a particular
%              epsilon and then computes the graph Laplacian of this graph.
%              The graph Laplacian can either be a weighted graph or a
%              simple adjacency computations. The weighted graphs can be
%              either a heat kernel weighting or just the Euclidean
%              distance weights. 
% 
% Inputs: 
%
%   data            - Can be any NxD data matrix, for this framework we 
%                     form the graph on the U eigenvectors from the SVD 
%                     decomposition of the affine representation of the 
%                     shape.  
%
%   p.epsilon       - Epsilon for epsilon neighborhood graph. 
%
%   p.graphType     - Flag for the type of graph to construct. 
%                     'eucDist' - Euclidean distances as the weights. 
%                     'heatKer' - Heat kernel weights. 
%                     'connect' - Just the connectivity graph using the
%                                 adjacency matrix. 
%
%   p.hkt            - Value for the heat kernel. 
%
% Outputs.
%
%   L                - Graph Laplacian.
% 
% Usage: Used in the affine invariance framework.
%
% -------------------------------------------------------------------------
function L = graphLaplacian_Clean(data, p)

A = pdist2(data, data).^2;    % Squared distance matrix. 

A(A > p.Epsilon) = 0;       % Create the epsilon graph. 
A = sparse(A);              % Euclidean distance weighted adjacency matrix. 
connPos = logical(A == 0);  % Connection positions.

switch p.GraphLapType
    case 'eucDist'
        
        D = diag(sum(A,2)); % Diagonal sum of weights.  
        L = D - A;          % Graph Laplacian.         
        
    case 'heatKer'  % Heat Kernel weights.
        
        A = exp(-A/p.hkt);      % Weighted adjacency matrix.
        A(connPos) = 0;
        D = diag(sum(A,2)); % Diagonal sum of weights.  
        L = D - A;          % Graph Laplacian. 
    
    case 'connect'  % Connectivity only.
        
        A = A > 0;          % Connectivity adjacency matrix. 
        D = diag(sum(A,2)); % Diagonal sum of weights.  
        L = D - A;          % Graph Laplacian. 
        
end

        