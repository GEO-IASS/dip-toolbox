function [net, tr] = trainAndProcess(imageVis, imageTarget)
% tranAndProcess(imageVis, imageTarget) takes image VIS train FF-ANN and
% creates estimation of target image. As a result returns enhanced
% information gain of imageTarget

TRAINING_SET_SIZE = 500;
LAYERS = [1, 1];

% convert input images into pixel vector useful for training
inputs = reshape(double(imageVis), size(imageVis, 1) * size(imageVis, 2), size(imageVis,3));
outputs = reshape(double(imageTarget), size(imageTarget, 1) * size(imageTarget, 2), size(imageTarget,3));

imgSize = size(inputs, 1);

subset = int64(rand(TRAINING_SET_SIZE, 1) * (imgSize - 1)) + 1;
ins = inputs(subset, :)';
outs = outputs(subset, :)';

net = feedforwardnet(LAYERS, 'trainscg');
net = configure(net, 'inputs', ins);
net = configure(net, 'outputs', outs);
net.trainParam.epochs = 10000;
[net, tr] = train(net, ins, outs);%, 'useParallel', 'yes', 'useGPU', 'yes');

gain = double(imageTarget) - reshape(net(inputs')', size(imageTarget, 1), size(imageTarget, 2), size(imageTarget,3));

end