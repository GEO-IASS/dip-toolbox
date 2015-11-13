function [igScaled, targetApprox] = informationGain(visible, target, areaSize)
% igScaled = informationGain(visible, target) - Method extrapolate target 
% image from visible one. This is made by feed forward neural network.
% Extrapolation of target image is then returned.
% igScaled = informationGain(visible, target, areaSize) - Area size
% processed by one neural network can be specified. Image is in this case
% cut into serveral squares, each used for one ANN training. Result is then
% constructed as bilinear interpolation of four neighboring neural networks
% around a pixel.

% This is workaround. If area size is greater than doubled size of the
% image only one network is trained.
if (nargin == 2)
    areaSize = 2 * max(size(visible,1), size(visible,2)) + 1;
end

% network preparation
nets = trainNetworks(areaSize, visible, target);
nets = reshape(nets, size(nets, 1) * size(nets,2), 1);

width = size(visible,1);
height = size(visible , 2);

% map describes how ANN are distributed over image. Map looks like:
%   1, 2, 0
%   3, 4, 0
%   0, 0, 0
% where zeros fill non complete squares on an image border
map = createMap(width, height, areaSize);
% pixel coordinates in two arrays
[x, y] = meshgrid(1:height, 1:width);
% inices of neural networks used for approximation and weighting vectors
% for bilinear interpolation
[seg, wx, wy] = getSegment(x, y, areaSize);

% formating of input pixel values
toProcess = reshape(double(visible), width * height, size(visible,3))';
% output array for approximation
q = zeros(width * height, size(target, 3), 4);

% pixel to neural network mapping
q1 = map(sub2ind(size(map), seg(:,1), seg(:,2), ones(size(seg,1),1)));
q2 = map(sub2ind(size(map), seg(:,1), seg(:,2), 2 * ones(size(seg,1),1)));
q3 = map(sub2ind(size(map), seg(:,1), seg(:,2), 3 * ones(size(seg,1),1)));
q4 = map(sub2ind(size(map), seg(:,1), seg(:,2), 4 * ones(size(seg,1),1)));

wy = reshape(wy, width*height, 1);
wx = reshape(wx, width*height, 1);

% cleaning around image borders
wy(q1 == 0 & q2 == 0) = 1;
wy(q3 == 0 & q4 == 0) = 0;

wx(q1 == 0 & q3 == 0) = 1;
wx(q2 == 0 & q4 == 0) = 0;

display('Computing approximation of target');

% processing of pixels - computation of approximation
for netId = 1:size(nets,1);
    ind = find(q1 == netId);
    q(ind, :, 1) = nets{netId}.net(toProcess(:, ind))';
    ind = find(q2 == netId);
    q(ind, :, 2) = nets{netId}.net(toProcess(:, ind))';
    ind = find(q3 == netId);
    q(ind, :, 3) = nets{netId}.net(toProcess(:, ind))';
    ind = find(q4 == netId);
    q(ind, :, 4) = nets{netId}.net(toProcess(:, ind))';
end        

display('Final bilinear interpolation');

wx = reshape(wx, width*height, 1) * ones(1,size(target,3));
wy = reshape(wy, width*height, 1) * ones(1,size(target,3));

targetApprox =  q(:,:,1) .* (1 - wx) .* (1 - wy) ...
            + q(:,:,2) .* wx .* (1 - wy) ...
            + q(:,:,3) .* (1 - wx) .* wy ...
            + q(:,:,4) .* wx .* wy;               

targetApprox = reshape(targetApprox, width, height, size(target,3));
igScaled = rescaleRange(abs(target - targetApprox));

end