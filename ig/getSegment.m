function [segment, wx, wy] = getSegment(x, y, areaSize)
% [segment, weightX, weightY] = getSegment(x, y, areaSize) for position x, y 
% in image determine coordinates in sense of areaSize and weight of left
% topcolumn. This method is supporting and without other methods does not
% have sense.

    xx = ceil(x / areaSize);
    column = floor(xx);
    wx = xx - column;
    
    yy = ceil(y / areaSize);
    row = floor(yy);
    wy = yy - row;
    
    segment = [reshape(column, size(x,1) * size(x,2), 1)'; reshape(row, size(x,1) * size(x,2), 1)']';
    
end