function phantom = createPhantom(pattern, materials)

    phantom = {};
    width = size(pattern, 1);
    height = size(pattern, 2);
    
    % create clean dataset
    phantom.clean = reshape(materials(pattern, :, 1), width, height, 32);
    
    
    % generate white noise according to material variances
    phantom.dirt = randn(width, height, 32);
    phantom.dirt = phantom.dirt .* sqrt(reshape(materials(pattern, :, 2), width, height, 32));
    
    
    % generate final phantom
    phantom.work = phantom.clean + phantom.dirt;
    %phantom.work(phantom.work < 0) = 0;
    %phantom.work(phantom.work > 1) = 1;
end