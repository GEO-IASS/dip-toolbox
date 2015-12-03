function anns = trainNetworks(imageVis, imageTarget, areaSize)
% anns = trainNetworks(imageVis, imageTarget, areaSize) function split 
% image with boundary into squares of areaSize. For each square train one 
% neural network. Trained networks are then returned in a matrix of cells.

width = size(imageVis, 1);
height = size(imageVis, 2);

xs = -areaSize/2:areaSize:width;
ys = -areaSize/2:areaSize:height;

anns = cell(size(xs,1), size(ys,1));
gainSum = zeros(size(xs,1), size(ys,1));

display([num2str(size(xs,2) * size(ys,2)), ' networks will be trained.']);

i = 1;
col = 1;
for x = xs
    row = 1;
    for y = ys
        subVis = imageVis(max(1,x): min(width, x + areaSize), max(1,y) : min(height, y + areaSize), :);
        subTarget = imageTarget(max(1,x): min(width, x + areaSize), max(1,y) : min(height, y + areaSize), :);
        [net, tr, gain] = trainAndProcess(subVis, subTarget);
        gainSum(col,row) = sum(sum(sum(gain)));
        display(['[',num2str(col), ',', num2str(row), '] network is ready. Performance: ', num2str(tr.best_perf), ' gain: ', num2str(gainSum(col,row))]);
        i = i + 1;
        anns{col, row}.net = net;
        row = row + 1;
    end
    col = col + 1;
end

% ok, let's assume that some training has failed ... try to recompute worst
% results
for i=1:size(xs,2) * size(ys,2)
    maxValue = max(gainSum(:));
    [x, y] = find(gainSum == maxValue);
    display(['[',num2str(x), ',', num2str(y), '] network need to be recomputed.']);
    
    subVis = imageVis(max(1,x): min(width, x + areaSize), max(1,y) : min(height, y + areaSize), :);
    subTarget = imageTarget(max(1,x): min(width, x + areaSize), max(1,y) : min(height, y + areaSize), :);
    [net, tr, gain] = trainAndProcess(subVis, subTarget);
    newGainSum = sum(sum(sum(gain)));
    if (newGainSum < gainSum(x,y))
        display(['Performance: ', num2str(tr.best_perf), ' gain: ', num2str(newGainSum)]);
        gainSum(x,y) = newGainSum;
        anns{x, y}.net = net;
    else
        display(['New network is not better. Current gain: ', num2str(gainSum(x,y)), ' new gain: ', num2str(newGainSum)]);
    end
    
end
end
