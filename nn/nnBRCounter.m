statsbr = zeros(20,30);
netsbr = cell(20,30);
timebr = zeros(20,30);
for f=1:20
    for classes=3:15
    	disp(['features:', num2str(f*5), ' classes:', num2str(classes)]);
        features = f * 5;
        net = feedforwardnet([features, classes], 'trainbr');
        net = configure(net, 'inputs', inSmall');
        net = configure(net, 'outputs', outSmall');
        tic
        net = train(net, inSmall', outSmall');
        timebr(f, classes) = toc;
        simOut = net(sim(:,1:16)');
        netsbr{f, classes} = net;
        statsbr(f, classes) = sum(sum((sim(:,17:32) - simOut').^2));
    end
end

save nn-profile-br.mat statsbr netsbr timebr
