function [net, perf] = trainANN(dataset, nnLayers, trainSetSize)
% estimateNirBands(dataset, nnLayers) creates neural network which 
% estimates from first 16 dimensions of dataset.work(:,:,1:16) next 16 
% dimensions of dataset.work(:,:,17:32). As a result we obtain computed estimation error on 
% dataset.clean, trained neural network and 

if (nargin < 3)
    trainSetSize = size(dataset,1) * size(dataset,2);
end

height = size(dataset,1);
width = size(dataset,2);
ins = reshape(dataset(:,:,1:16), width * height, 16);
outs = reshape(dataset(:,:,17:32), width * height, 16);

subset = int64(rand(trainSetSize, 1) * (size(dataset,1) * size(dataset,2) - 1)) + 1;
input = ins(subset, :);
output = outs(subset, :);

%gpuInput = nndata2gpu(input');
%gpuOutput = nndata2gpu(output');

%display('License reached, going to compute in parallel');

net = feedforwardnet(nnLayers, 'trainscg');
net = configure(net, 'inputs', input');
net = configure(net, 'outputs', output');
net.trainParam.epochs = 10000;
[net, perf] = train(net, input', output', 'useGPU', 'only');

end
