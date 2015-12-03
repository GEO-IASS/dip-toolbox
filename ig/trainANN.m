function [net, tr] = trainANN(imageVis, imageTarget)
% [net, tr] = tranAndProcess(imageVis, imageTarget) train feed forward
% neural network, where inputs are pixels of visible image and targets are
% pixels of imageTarget (expected different modality here). Size of
% training set is limitted (50k) and size of ANN is [50,10]. If you want
% vary those parameters edit this method.

TRAINING_SET_SIZE = min(10000, size(imageVis,1) * size(imageVis,2));
LAYERS = [15, 10];

% convert input images into pixel vector useful for training
inputs = reshape(double(imageVis), size(imageVis, 1) * size(imageVis, 2), size(imageVis,3));
outputs = reshape(double(imageTarget), size(imageTarget, 1) * size(imageTarget, 2), size(imageTarget,3));

imgSize = size(inputs, 1);

% select only TRAINING_SET_SIZE pixels
subset = int64(rand(TRAINING_SET_SIZE, 1) * (imgSize - 1)) + 1;
ins = inputs(subset, :)';
outs = outputs(subset, :)';

net = feedforwardnet(LAYERS, 'trainscg');
net = configure(net, 'inputs', ins);
net = configure(net, 'outputs', outs);
net.trainParam.epochs = 10000;

try
    gpuDevice
    [net, tr] = train(net, ins, outs, 'useParallel', 'yes', 'useGPU', 'yes');
catch noGPU
    [net, tr] = train(net, ins, outs);
end

end