function [nets, partitions] = prepare(visible, target, areaSize)
% partitions = prepare(visible, target, areaSize) method train neural
% networks for visible to target extrapolation according to area size.
% Partitioning parameters and trained ANN are returned

nets = trainNetworks(areaSize, visible, target);
nets = reshape(nets, size(nets, 1) * size(nets,2), 1);

width = size(visible, 2);
height = size(visible, 1);

map = createMap(width, height, areaSize);
[x, y] = meshgrid(1:width, 1:height);
[seg, wx, wy] = getSegment(x, y, areaSize);

q{1} = map(sub2ind(size(map), seg(:,2), seg(:,1), ones(size(seg,1),1)));
q{2} = map(sub2ind(size(map), seg(:,2), seg(:,1), 2 * ones(size(seg,1),1)));
q{3} = map(sub2ind(size(map), seg(:,2), seg(:,1), 3 * ones(size(seg,1),1)));
q{4} = map(sub2ind(size(map), seg(:,2), seg(:,1), 4 * ones(size(seg,1),1)));

wy = reshape(wy, width*height, 1);
wx = reshape(wx, width*height, 1);

wy(q{1} == 0 & q{2} == 0) = 1;
wy(q{3} == 0 & q{4} == 0) = 0;

wx(q{1} == 0 & q{3} == 0) = 1;
wx(q{2} == 0 & q{4} == 0) = 0;

partitions.wx = wx;
partitions.wy = wy;
partitions.q = q;

end