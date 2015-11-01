function computeANN5( M, layers, fileID )
% computeANN(phantomID, M, layersID,fileID) - function for cesnet computing. 
% Function takes one phantom from directory and train one FF-ANN. Results 
% (error vectors and network itself) stores into ouput file.

cd '/storage/ostrava1/home/gimli/dip-toolbox/phantom';
rng('shuffle');

load('materials-firenze.mat');
pattern = createPhantomPattern(int16(500/M), 500, M, 120, 0.02);
permutation = randperm(120);
mStatsPerm(1:120,:,:) = mStats(permutation, :, :); % mStats is loaded from materials-firenze
mStatsPerm(121:240,:,:) = mStats(120+permutation, :, :);
phantom = createPhantom(pattern, mStatsPerm);

nnLayers = ones(1, layers) * 50;

height = size(phantom.clean,1);
width = size(phantom.clean,2);

trainSetSize = min(height*width, 10^5);

[net, perf] = trainANNsingleCore(phantom.work, nnLayers, trainSetSize); 

oneLayer = reshape(phantom.clean(1:height, 1, 1:16), height, 16);
twoLayers = reshape(phantom.clean(1:height, width, 1:16), height, 16);

oneLayerNir = net(oneLayer')';
twoLayersNir = net(twoLayers')';

err.oneLayer = (oneLayerNir - reshape(phantom.clean(1:height, 1, 17:32), height, 16)).^2;
err.twoLayers = (twoLayersNir - reshape(phantom.clean(1:height, width, 17:32), height, 16)).^2;

filename = ['materials-rnd-M', num2str(M), '-layers', num2str(layers), '-c', num2str(fileID)];

save(filename, 'err', 'net', 'perf', 'mStatsPerm');

end

