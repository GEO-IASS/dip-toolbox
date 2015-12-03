function extrapolated = extrapolate(visible, nets, imagePartitions)
% extrapolated = extrapolate(visible, nets, imagePartitions) extrapolates
% visible image by using neural networks and partitionin object

wx = imagePartitions.wx;
wy = imagePartitions.wy;
q = imagePartitions.q;

width = size(visible, 2);
height = size(visible, 1);
bands = nets{1}.net.output.size;

toProcess = reshape(double(visible), width * height, size(visible,3))';
approx = zeros(width * height, bands, 4);

display('Computing approximation of target');

for netId = 1:size(nets,1);
    ind = find(q{1} == netId);
    approx(ind, :, 1) = nets{netId}.net(toProcess(:, ind), 'useGPU', 'yes')';
    ind = find(q{2} == netId);
    approx(ind, :, 2) = nets{netId}.net(toProcess(:, ind), 'useGPU', 'yes')';
    ind = find(q{3} == netId);
    approx(ind, :, 3) = nets{netId}.net(toProcess(:, ind), 'useGPU', 'yes')';
    ind = find(q{4} == netId);
    approx(ind, :, 4) = nets{netId}.net(toProcess(:, ind), 'useGPU', 'yes')';
end        

display('Final bilinear interpolation');

wx = reshape(wx, width*height, 1) * ones(1, bands);
wy = reshape(wy, width*height, 1) * ones(1, bands);

try 
    gpuDevice(1);

    wxGpu = gpuArray(wx);
    wyGpu = gpuArray(wy);

    approxGpu = gpuArray(approx);

    igScaled =  approxGpu(:,:,1) .* (1 - wxGpu) .* (1 - wyGpu) ...
                + approxGpu(:,:,2) .* wxGpu .* (1 - wyGpu) ...
                + approxGpu(:,:,3) .* (1 - wxGpu) .* wyGpu ...
                + approxGpu(:,:,4) .* wxGpu .* wyGpu;            
catch
    display('GPU device problem. Computing on CPU ...');
                
    igScaled =  approx(:,:,1) .* (1 - wx) .* (1 - wy) ...
                + approx(:,:,2) .* wx .* (1 - wy) ...
                + approx(:,:,3) .* (1 - wx) .* wy ...
                + approx(:,:,4) .* wx .* wy;                
end
        
extrapolated = reshape(igScaled, height, width, bands);

end