statslm = zeros(20,30);
statsscg = zeros(20,30);
netslm = cell(20,30);
netsscg = cell(20,30);
timelm = zeros(20,30);
timescg = zeros(20,30);
for f=1:20
    for classes=1:30
        features = f * 5;
        net = feedforwardnet([features, classes], 'trainlm');
        net = configure(net, 'inputs', inputs);
        net = configure(net, 'outputs', output);
        tic
        net = train(net, inputs, output);
        timelm(f, classes) = toc;
        simOut = net(simIn');
        netslm{f, classes} = net;
        statslm(f, classes) = sum(sum((sim(:,17:32) - simOut').^2));
        
        net = feedforwardnet([features, classes], 'trainscg');
        net = configure(net, 'inputs', inputs);
        net = configure(net, 'outputs', output);
        tic
        net = train(net, inputs, output);
        timescg(f, classes) = toc;
        simOut = net(simIn');
        netsscg{f, classes} = net;
        statsscg = sum(sum((sim(:,17:32) - simOut').^2));
    end
end

save nn-profile.mat statslm statsscg netslm netsscg timelm timescg