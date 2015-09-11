function [err, net, perf] = estimateNirBands(dataset, nnLayers, trainSetSize)
% estimateNirBands(dataset, nnLayers) creates neural network which 
% estimates from first 16 dimensions of dataset.work(:,:,1:16) next 16 
% dimensions of dataset.work(:,:,17:32). As a result we obtain computed estimation error on 
% dataset.clean, trained neural network and 

if (nargin < 3)
    trainSetSize = size(dataset.work,1) * size(dataset.work,2);
end

height = size(dataset.work,1);
width = size(dataset.work,2);
ins = reshape(dataset.work(:,:,1:16), width * height, 16);
outs = reshape(dataset.work(:,:,17:32), width * height, 16);

subset = int64(rand(trainSetSize, 1) * (size(dataset.work,1) * size(dataset.work,2) - 1)) + 1;
input = ins(subset, :);
output = outs(subset, :);

net = feedforwardnet(nnLayers, 'trainscg');
net = configure(net, 'inputs', input');
net = configure(net, 'outputs', output');
net.trainParam.epochs = 1000;
[net, perf] = train(net, input', output', 'useGPU', 'yes');

oneLayer = reshape(dataset.clean(1:height/12:height, 1, 1:16), 12, 16);
twoLayers = reshape(dataset.clean(1:height/12:height, width, 1:16), 12, 16);

oneLayerNir = net(oneLayer')';
twoLayersNir = net(twoLayers')';

err.oneLayer = (oneLayerNir - reshape(dataset.clean(1:height/12:height, 1, 17:32), 12, 16)).^2;
err.twoLayers = (twoLayersNir - reshape(dataset.clean(1:height/12:height, width, 17:32), 12, 16)).^2;
end