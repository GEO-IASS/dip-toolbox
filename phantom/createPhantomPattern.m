function phantomPattern = createPhantomPattern(segmentRows, maxWidth, materialsCount, underdrawingsCoverage)
% createPhantomPattern creates 2D matrix where each pixel contains id of
% material. This function creates horizontal stripes. Each stripe
% represents one used material. On the right side (according to specified
% underdrawingCoverage) simulation of sandwich with underdrawings is
% created.

% estimation of optimal pattern size (according to maxWidth and
% underdrawingsCoverage)
underdrawingCols = floor(maxWidth * underdrawingsCoverage);
cols = int16(underdrawingCols / underdrawingsCoverage);

% allocate output pattern
phantomPattern = zeros(segmentRows * materialsCount, cols);

row = 1;
for m=1:materialsCount
    phantomPattern(row:row+segmentRows-1, 1:cols - underdrawingCols) = m;
    phantomPattern(row:row+segmentRows-1, cols - underdrawingCols + 1:cols) = m + materialsCount;
    row = row + segmentRows;
end

end