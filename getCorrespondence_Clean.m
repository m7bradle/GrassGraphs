function corr = getCorrespondence_Clean(X,Y,p)

% Compute the distance matrix between X and Y. 
distMat = correspondenceDistance_Clean(X, Y, p);

% Sort the distance matrix. 
[~, sortInd] = sort(distMat,2);

% Pull the first column. 
corr = sortInd(:,1);