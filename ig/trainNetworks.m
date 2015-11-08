function anns = trainNetworks(areaSize, imageVis, imageTarget)
% anns = trainNetworks(areaSize, image) function split image with boundary 
% into squares of areaSize. For each square train neural network. Trained
% networks are then returned ordered from left to right and top to bottom.

width = size(imageVis, 1);
height = size(imageVis, 2);

xs = -areaSize/2:areaSize:width;
ys = -areaSize/2:areaSize:height;

anns = cell(size(xs,1), size(ys,1));

display([num2str(size(xs,2) * size(ys,2)), ' networks will be trained.']);

i = 1;
col = 1;
for x = xs
    row = 1;
    for y = ys
        subVis = imageVis(max(1,x): min(width, x + areaSize), max(1,y) : min(height, y + areaSize), :);
        subTarget = imageTarget(max(1,x): min(width, x + areaSize), max(1,y) : min(height, y + areaSize), :);
        [net, tr] = trainAndProcess(subVis, subTarget);
        display([num2str(i), ' network ready. Performance: ', num2str(tr.best_perf)]);
        i = i + 1;
        anns{col, row}.net = net;
        row = row + 1;
    end
    col = col + 1;
end

end