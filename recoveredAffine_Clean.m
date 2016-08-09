function rA = recoveredAffine_Clean(cX, cY)

% Recover the affine transformation. 
numCorr = size(cX,1); % Number of correspondences.
cX = [cX ones(numCorr,1)];
cY = [cY ones(numCorr,1)];
rA = ((cX'*cX)^-1)*cX'*cY;