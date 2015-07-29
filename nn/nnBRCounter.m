%statsbr = zeros(20,30);
%netsbr = cell(20,30);
%timebr = zeros(20,30);
for f=20:20
    for classes=15:15
        features = f * 5;
        net = feedforwardnet([features, classes], 'trainbr');
        net = configure(net, 'inputs', inputs);
        net = configure(net, 'outputs', output);
%        tic
        net = train(net, inputs, output);
%        timebr(f, classes) = toc;
        simOut = net(simIn');
%        netsbr{f, classes} = net;
%        statsbr(f, classes) = 
        sum(sum((sim(:,17:32) - simOut').^2))
    end
end

%save nn-profile-br.mat statsbr netsbr timebr