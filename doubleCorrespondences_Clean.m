function [cScore, corIndVec, cXY] = doubleCorrespondences_Clean(X,Y, p)
% [cScore, corIndVec, cXY] = doubleCorrespondences_Clean(X,Y, p)

% Get correspondences from source to target. 
cXY = getCorrespondence_Clean(X,Y,p);

% Get correspondences from target to source. 
cYX = getCorrespondence_Clean(Y,X,p);

numElem = size(cXY,1);
corIndVec = zeros(numElem,1);
% Loop through the number of elements. 
for i = 1 : numElem

    % The i indices are the entries of X with X fixed to find the 
    % correspondences. Find the ith index in Y. Record this value. 
    ithYVal = cXY(i);
    
    % Take the index i (which is the index in X) and find where it is equal
    % to in the cYX vector. The find function will return an index into the 
    % correspondence vector. This index is the actual correspondence value 
    % in the fixed target because we are in the YX case now. We will check
    % if this index value is equal to the ith index in Y found above. 
    % But there are three cases that could be returned by find. 
    iPosIncYX = find(cYX == i);
    numOcc = numel(iPosIncYX);

    % The index i is found only once in the source vector on the YX side. 
    if (numOcc == 1)
        
        % Use the index returned by find and check if it is equal to
        % the ith index into cXY. % If it is equal then put a one in the 
        % correspondence index vector. % If not put a zero. 
        corIndVec(i) = iPosIncYX == ithYVal;
    end
    
    
    % The values are equal but have multiple instances. The find
    % indices will be the positions that we need to compare to the ith
    % value in the correspondence vector in the XY case. 
    if (numOcc > 1)
        
            % Find where the indices values are equal to ith correspondence
            % in the target in the XY case. % There are two cases, it is
            % equal or not equal.
            indEqcXY = find(iPosIncYX == ithYVal);
            
            if isempty(indEqcXY == 1)
                % Else it won't be equal and we put a 0 in the check vector
                % for the ith position. The ith position already has a zero
                % through the initialization, so just leave the zero. 
                continue;
            else
                % If it is equal put a 1 in the check vector. Keep in mind
                % it will only be equal to one point. 
                corIndVec(i) = 1;
            end
    end
    
    % The value does not exist in the vector. Then we just put a zero
    % in the check vector. The corIndVec already has a zero initialized. So
    % this case is not explicitly needed.
end % for i = 1 : numElem
corIndVec = logical(corIndVec);

if (strcmp(p.ScoreType,'MinScore'))
    cX = X(corIndVec,:);
    cY = Y(cYX(corIndVec),:);
    cScore = norm(cX - cY, 'fro')^2;    
end

if (strcmp(p.ScoreType,'NumCorr'))
    cScore = sum(corIndVec);    
end



