function computeANN2( phantomID, M, layersID, fileID)
% computeANN(phantomID, M, layersID,fileID) - function for cesnet computing. 
% Function takes one phantom from directory and train one FF-ANN. Results 
% (error vectors and network itself) stores into ouput file.

cd '/storage/ostrava1/home/gimli/dip-toolbox/phantom';

phantomName = ['phantom-m', num2str(M), '-', num2str(phantomID)];
data = load(phantomName);
load('layersStore');

height = size(data.phantom.clean,1);
width = size(data.phantom.clean,2);

trainSetSize = min(height*width, 10^5);

[net, perf] = trainANN(data.phantom.work, layers{layersID}, trainSetSize); 

oneLayer = reshape(data.phantom.clean(1:height/12:height, 1, 1:16), 12, 16);
twoLayers = reshape(data.phantom.clean(1:height/12:height, width, 1:16), 12, 16);

oneLayerNir = net(oneLayer')';
twoLayersNir = net(twoLayers')';

err.oneLayer = (oneLayerNir - reshape(data.phantom.clean(1:height/12:height, 1, 17:32), 12, 16)).^2;
err.twoLayers = (twoLayersNir - reshape(data.phantom.clean(1:height/12:height, width, 17:32), 12, 16)).^2;

filename = ['output-P', num2str(phantomID), '-M', num2str(M), '-L', num2str(layersID), '-c', num2str(fileID)];

save(filename, 'err', 'net', 'perf');

end

