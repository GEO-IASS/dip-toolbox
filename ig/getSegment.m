function [segment, wx, wy] = getSegment(x, y, areaSize)
% [segment, weightX, weightY] = getSegment(x, y, areaSize) for position x, y 
% in image determine coordinates in sense of areaSize and weight of left
% topcolumn. This method is supporting and without other methods does not
% have sense.

    xx = double(x) / areaSize;
    column = ceil(xx);
    wx = xx - column + 1;
    
    yy = double(y) / areaSize;
    row = ceil(yy);
    wy = yy - row + 1;
    
    segment = [reshape(column, size(x,1) * size(x,2), 1)'; reshape(row, size(x,1) * size(x,2), 1)']';
    
end