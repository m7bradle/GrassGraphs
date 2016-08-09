%--------------------------------------------------------------------------
% Function:    correspondenceData_Clean
% Description: This functions uses the best eigenvector flip and
%              applies the correspondence index associated with that flip.
% 
% Inputs: 
%
%   origSrcData        - Original source data.
%
%   origTargData       - Original target data. 
%   
%   singCorrIndVecCell - Cell that contains the single correspondence
%                        indices found from removing the multiple
%                        correspondences. Each cell contains the indices of
%                        the particular eigenvector flip that minimized the
%                        score. 
%   totScoreVec         - Total score vector, contains the scores
%                         associated with all the flips from the
%                         eigenvector correspondence calculation. 
% 
%   corrIndCell         - Cell that contains the correspondence indices for
%                         each eigenvector flip. 
%
%   p                   - GrassGraphs parameters.
%   
% Outputs:
%
%   srcCorrPoints       - Source correspondence points. The points have
%                         been adjusted using the correspondence indices
%                         obtained from the different assignment
%                         algorithms.
%
%   targCorrPoints      - Target correspondence points. The points have
%                         been adjusted using the correspondence indices
%                         obtained from the different assignment
%                         algorithms.
%
%   optSingCorrIndVec   - Optimal single correspondence index vector.
% 
% Usage: Used in the affine invariance framework.
% -------------------------------------------------------------------------
function [srcCorrPoints, targCorrPoints, optSingCorrIndVec]...
     = correspondenceData_Clean(...
            singCorrIndVecCell, totScoreVec, corrIndCell, origSrcData,...
            origTargData, p) 

% Find the index corresponding to the permutation of the target shape that 
% has the least total distance score.
[~, optPermInd] = max(totScoreVec);

% Optimal single correspondence index vector. 
optSingCorrIndVec = singCorrIndVecCell{optPermInd};

% Optimal correspondence index. 
optCorrInd = corrIndCell{optPermInd};

% Choosing a subset of the source points as the initial correspondence on
% the source shape or choosing all the source points as the initial
% correspondence, this case will occur when we use a dense correspondence.
% Other correspondence methods can be added later on by using cases in
% instead of an if statement. 
if (strcmp(p.CorrMethod, 'minDistThrowOut'))
    
    % Correspondences of source shape from the optimal permutation. 
    srcCorrPoints = origSrcData(optSingCorrIndVec,:);
    
    % Correspondence of the target shape from optimal permutation. 
    targCorrPoints = origTargData(optCorrInd(optSingCorrIndVec),:);
     
    % Get the number of correspondences. 
    numCorr = size(srcCorrPoints,1);
    
    % If the number of correspondences is less than 6 for the 2D case
    % choose the first 6 data points in the dataset as the correspondences.
    if (numCorr < p.CorrThresh)
        
        % Number of correspondences to meet the threshold. 
        numCorrToMeetThresh = p.CorrThresh - numCorr;
        randVec = randperm(size(origSrcData,1));
        randInd = randVec(1:numCorrToMeetThresh);
        
        % Add random points to the source correspondence points.
        srcCorrPoints = [srcCorrPoints; origSrcData(randInd,:)];
        
        % Add random points to the target correspondence points.
        targCorrPoints = [targCorrPoints; origTargData(randInd,:)];
        disp('No correspondences so random ones are taken');
    end 
end


















