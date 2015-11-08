function igScaled = informationGain(visible, target, areaSize)
% igScaled = informationGain(visible, target, areaSize) - function estimate 
% target image from visible one. This is made by FF-ANN. Estimate is than
% subtracted from the target values, this way we obtain information gain.
% IG is than scaled into range 0-1.

nets = trainNetworks(areaSize, visible, target);

width = size(visible,1);
height = size(visible , 2);
igScaled = zeros(size(target));

map = createMap(width, height, areaSize);

[x, y] = meshgrid(1:width, 1:height);

[seg, wx, wy] = getSegment(x, y, areaSize);

toProcess = reshape(double(visible), width * height, size(visible,3))';
q = zeros(width, height, 4);

wy(map(sub2ind(size(map), seg(:,1), seg(:,2), ones(size(seg,1),1))) == 0 ...
    & map(sub2ind(size(map), seg(:,1), seg(:,2), 2 * ones(size(seg,1),1))) == 0) = 1;

wy(map(sub2ind(size(map), seg(:,1), seg(:,2), 3 * ones(size(seg,1),1))) == 0 ...
    & map(sub2ind(size(map), seg(:,1), seg(:,2), 4 * ones(size(seg,1),1))) == 0) = 0;

wx(map(sub2ind(size(map), seg(:,1), seg(:,2), ones(size(seg,1),1))) == 0 ...
    & map(sub2ind(size(map), seg(:,1), seg(:,2), 3 * ones(size(seg,1),1))) == 0) = 1;

wx(map(sub2ind(size(map), seg(:,1), seg(:,2), 2 * ones(size(seg,1),1))) == 0 ...
    & map(sub2ind(size(map), seg(:,1), seg(:,2), 4 * ones(size(seg,1),1))) == 0) = 0;

q(map ~= 0) = nets{map ~= 0}.net(toProcess);
        
        
igScaled(x, y, :) =  q(:,:,1) * (1 - wx) * (1 - wy) ...
            + q(:,:,2) * wx * (1 - wy) ...
            + q(:,:,3) * (1 - wx) * wy ...
            + q(:,:,4) * wx * wy;

end