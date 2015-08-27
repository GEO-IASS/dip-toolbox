function phantom = createPhantom(pattern, materials)
% createPhantom(pattern, materials) creates "multimodal dataset" simulating
% materials on specified pattern. Method creates 32 modalities (according
% to firenze scanner) which correspond to materials behavior.

% Expected is pattern - matrix with indices of used material for each
% position and materials 3D matrix [material, modality, moment]. Moments
% stored here are two - mean value and variance

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