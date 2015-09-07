function [err, net] = estimateNirBands(dataset, nnLayers)
% estimateNirBands(dataset, nnLayers) creates neural network which 
% estimates from first 16 dimensions of dataset.work(:,:,1:16) next 16 
% dimensions of dataset.work(:,:,17:32). As a result we obtain computed estimation error on 
% dataset.clean, trained neural network and 

height = size(dataset.work,1);
width = size(dataset.work,2);
ins = reshape(dataset.work(:,:,1:16), width * height, 16);
outs = reshape(dataset.work(:,:,17:32), width * height, 16);

net = feedforwardnet(nnLayers, 'trainscg');
net = configure(net, 'inputs', ins');
net = configure(net, 'outputs', outs');
net.trainParam.epochs = 1000;
net = train(net, ins', outs', 'useGPU', 'yes');

oneLayer = reshape(dataset.clean(1:height/12:height, 1, 1:16), 12, 16);
twoLayers = reshape(dataset.clean(1:height/12:height, width, 1:16), 12, 16);

oneLayerNir = net(oneLayer')';
twoLayersNir = net(twoLayers')';

err.oneLayer = (oneLayerNir - reshape(dataset.clean(1:height/12:height, 1, 17:32), 12, 16)).^2;
err.twoLayers = (twoLayersNir - reshape(dataset.clean(1:height/12:height, width, 17:32), 12, 16)).^2;
end