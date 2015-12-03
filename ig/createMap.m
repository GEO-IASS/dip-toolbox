function map = createMap(width, height, areaSize)
% map = createMap(width, height, areaSize) creates a map for bilinear
% interpolation of pixels. Whole image is split into rectangles of
% areaSize, each pixel is than approximated from neighboring areas.

cols = ceil(width/areaSize);
rows = ceil(height/areaSize);

map = zeros(rows, cols, 4); % necessary to add left and right border

coords = [1, 2, 2 + cols, 3 + cols];
for row=1:rows    
    for column=1:cols;    
        map(row, column, :) = coords;
        coords([1,3]) = coords([2,4]);
        coords([2,4]) = coords([2,4]) + 1;
    end
    coords = [coords(2), coords(2) + 1, coords(4), coords(4) + 1];
end

if (width - ceil((width - areaSize/2) / areaSize) * areaSize > 0)
    map(cols, :, [2, 4]) = 0;
end

if height - ceil((height - areaSize/2) / areaSize) * areaSize > 0
    map(:, rows, [3, 4]) = 0;
end

%map = reshape(map, cols * rows, 4);

end