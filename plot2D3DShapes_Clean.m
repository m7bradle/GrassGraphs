function plot2D3DShapes_Clean(X,Y,varargin)

% plot2D3DShapes(X,Y,varargin)
% position = varargin{1};
% titleStr = varargin{2};

% X must be NxD.
if (nargin > 2)
    legendStr = varargin{1};
end

if (nargin > 3)
    titleStr = varargin{2};
end

if (nargin > 4)
   position = varargin{3};
end

titleStrExist = exist('titleStr');
legendStrExist = exist('legendStr');
positionStrExist = exist('position');

% Check if X and Y are N x D. 
[numXRow, numXCol] = size(X);
if (numXRow < numXCol)
    X = X';
end

[numYRow, numYCol] = size(Y);
if (numYRow < numYCol)
    Y = Y';
end

[~, nDim] = size(X); 

% Show the shape.
if (nDim == 2)
    % 2D plots. 
    f1 = figure;
    if (positionStrExist == 1)        
        movegui(f1, position);
    else
        
    end
    plot(X(:,1), X(:,2), 'r.'); hold on; 
    plot(Y(:,1), Y(:,2), 'bo','Markersize',3);
    
    if (titleStrExist == 1)
        title(titleStr);
    end
    
    if (legendStrExist == 1)
        legend(legendStr{1}, legendStr{2});
    end
else
    % 3D plots. 
    f1 = figure;
    if (positionStrExist == 1)
        movegui(f1, position);
    else
        
    end
    plot3(X(:,1), X(:,2), X(:,3), 'r.', 'Linewidth', 1); hold on; 
    plot3(Y(:,1), Y(:,2), Y(:,3), 'bo', 'Linewidth', 1);
    
    if (titleStrExist == 1)
        title(titleStr);
    end
    
    if (legendStrExist == 1)
        legend(legendStr{1}, legendStr{2});
    end
end