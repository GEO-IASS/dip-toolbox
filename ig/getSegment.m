function [segment, wx, wy] = getSegment(x, y, areaSize)
% [column, row, weightX, weightY] = getSegment(x, y, areaSize) for position x, y 
% in image determine coordinates in sense of areaSize and weight of left
% topcolumn. This method is supporting and without other methods does not
% have sense.

    xx = (x + areaSize/2) / areaSize + 1;
    column = floor(xx);
    wx = xx - column;
    
    yy = (y + areaSize/2) / areaSize + 1;
    row = floor(yy);
    wy = yy - row;
    
    segment = [reshape(column, size(x,1) * size(x,2), 1)'; reshape(row, size(x,1) * size(x,2), 1)']';
    
end