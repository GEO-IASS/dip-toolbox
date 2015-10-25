function [err, net, perf] = computeANN6(nnSize, fileID)
% computeANN(phantomID, M, layersID,fileID) - function for cesnet computing. 
% Function takes one phantom from directory and train one FF-ANN. Results 
% (error vectors and network itself) stores into ouput file.

%cd '/storage/ostrava1/home/gimli/dip-toolbox/phantom';

load('rgbPhantom');
nnLayers = [5,1] * nnSize;

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

filename = ['separeRGB-l', num2str(layers), '-c', num2str(fileID)];

save(filename, 'err', 'net', 'perf');

end

