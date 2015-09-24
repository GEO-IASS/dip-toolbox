function computeANN7( coverage, layerID, fileID )
% computeANN7(underdrawing coverage, layersID, fileID) 
% another script for ANN training in this case coverage of phantom by
% underdrawing can vary. New phantom with specified coverage is generated
% from ALMA-materials.

cd '/storage/ostrava1/home/gimli/dip-toolbox/phantom';

load('alma-materials.mat');
pattern = createPhantomPattern(40, 500, 12, 12, double(coverage)/100);
phantom = createPhantom(pattern, materials);

load('layersStore.mat');
nnLayers = layers{layerID};

height = size(phantom.clean,1);
width = size(phantom.clean,2);

trainSetSize = min(height*width, 10^5);

[net, perf] = trainANN(phantom.work, nnLayers, trainSetSize); 

oneLayer = reshape(phantom.clean(1:height, 1, 1:16), height, 16);
twoLayers = reshape(phantom.clean(1:height, width, 1:16), height, 16);

oneLayerNir = net(oneLayer')';
twoLayersNir = net(twoLayers')';

err.oneLayer = (oneLayerNir - reshape(phantom.clean(1:height, 1, 17:32), height, 16)).^2;
err.twoLayers = (twoLayersNir - reshape(phantom.clean(1:height, width, 17:32), height, 16)).^2;

filename = ['coverage-C', num2str(coverage), '-l', num2str(layers), '-c', num2str(fileID)];

save(filename, 'err', 'net', 'perf');

end

