function bestNetwork = trainNetworks(inputs, outputs, annCount, layers, trainingSetSize, useGPU)
% bestNetwork = trainNetworks(inputs, outputs, annCount, layers, trainingSetSize,
% useGPU)

% random shuffle before training
rng('shuffle');

% training set size definition
if (trainingSetSize)    
    % select only trainingSetSize pixels
    subset = int64(rand(trainingSetSize, 1) * (size(inputs,1) - 1)) + 1;
    inputs = inputs(subset, :)';
    outputs = outputs(subset, :)';
end

bestGain = Inf;

% recompute network several times
for i=1:annCount    
            
    net = feedforwardnet(layers, 'trainscg');
    net = configure(net, 'inputs', inputs);
    net = configure(net, 'outputs', outputs);
    net.trainParam.epochs = 10000;
    tic
    [net, tr] = train(net, inputs, outputs, 'useGPU', useGPU);
    time = toc / tr.num_epochs;
    display([num2str(time), 's time per epoch. Epochs: ', num2str(tr.num_epochs)]);
    
    gain = abs(outputs - net(inputs)) / (size(outputs, 1) * size(outputs, 2));    
    
    maxValue = max(gain(:));
    display(['Performance: ', num2str(tr.best_perf), ' gain: ', num2str(maxValue)]);
    
    if (maxValue < bestGain)
        display('Network saved as best result.');
        bestGain = maxValue;
        bestNetwork = net;
    end      
end

end