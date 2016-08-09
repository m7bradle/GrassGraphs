%--------------------------------------------------------------------------
% Function:    eigenDecompositionLBO_Clean
% Description: This function compute the eigenvectors and eigenvalues of
%              the graph Laplacian. It removes the constant eigenvector and
%              returns the number of eigenvector columns specified by the
%              user. 
%  
% [eVec, eVals] = eigenDecompositionLBO_Clean(L,p) 
% 
% Inputs: 
%
%   L                 - Graph Laplacian.
%
%   p.NumLBOnumEigVec - Number of eigenvectors to compute, this will include
%                       the zero eigenvector. 
%
%   p.CondFac         - Condition factor for scaling the Laplacian matrix. 
%
%   p.EVecToMatch     - Eigenvectors to use for finding the correspondence.
%                       The maximum number of elements in the vector will be
%                       numEigVec - 1. If the number of elements exceeds
%                       this then elements will be removed from the vector
%                       until the maximum number of elements allowed is
%                       achieved.
%                       e.g. eigVecsToMatch = [1 2 3];
%
%   eigSc             - Eigenvalue scaling. 
%   
% Outputs.
%
%   eVecs            - Eigenvectors from the Graph Laplacian. 
%
%   eVals            - Eigenvalues from the graph Laplacian. 
% 
% Usage: Used in the affine invariance framework.
% -------------------------------------------------------------------------
function [eVec, eVals] = eigenDecompositionLBO_Clean(L,p) 

numPoints = size(L,1); 

% Condition matrix for ill-conditioning of Laplacian. 
condMat = p.CondFac*eps*speye(numPoints);

% Compute the graph Laplacian on the shapes. 
[eVec, eVals] = eigs(L + condMat, p.NumLBOEvec,'SM');

% Eigenvector scaling with the eigenvalues.
if (p.eigSc == 1)
    % Scale the eigenvectors by 1/sqrt(eigenvalue)
    eVec = eVec*(inv(sqrt(eVals)));
end

% Remove the zeroth eigenvector. 
eVec(:,end) = [];  % Remove the last column, corresponds to zeroth evec.

% Flip the eigenvector matrices so the eigenvector correponding to the
% smallest eigenvalue is in the first column. 
eVec = fliplr(eVec);  % Source shape. 

% Number of eigenvectors used for the matching.
numEigVecToMatch = numel(p.EvecToMatch); 

% Number of eigenvectors remaining after removal of constant eigenvector.
numEigRem = p.NumLBOEvec - 1; 

% Remove the extra eigenvectors. If the number number of eigenvectors to
% match is more than the number of eigenvectors generated then the number
% of eigenvectors used to match is reduced by 1.
if (numEigVecToMatch > numEigRem)
    
    % Loop through the number of elements and remove the last element until
    % then number of elements is equal to the p.numLBOEvec - 1.
    while (numEigVecToMatch > numEigRem)
        
        % Remove the last element of the p.EvecToMatch vector. 
        p.EvecToMatch(end) = [];
        
        % Number of eigenvectors to use for the matching now. 
        numEigVecToMatch = numel(p.EvecToMatch);
    end
end   
    
% Choose the individual eigenvectors. 
eVec = eVec(:, p.EvecToMatch);
