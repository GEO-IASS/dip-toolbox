function trainNet(allBandsImg, roi, trainingSetSize, layers);
% cilem funkce je zjistit velikost trenovaci mnoziny, kdy uz aproximace
% dava pozadovane vysledky, taktez lze testovat velikost site

% argumenty: linearizovany obrazek, vystupni obrazek, velikost trenovaci
% mnoziny a velikost site

allBandsImgLin = reshape(allBandsImg, size(allBandsImg, 1) * size(allBandsImg, 2), size(allBandsImg,3));

imgSize = size(allBandsImgLin, 1);
bands = size(allBandsImgLin, 2);

subset = int32(rand(trainingSetSize,1) * imgSize);
ins = allBandsImgLin(subset, 1:16);
outs = allBandsImgLin(subset, 17:bands);

net = feedforwardnet(layers, 'trainscg');
net = configure(net, 'inputs', ins');
net = configure(net, 'outputs', outs');
net.trainParam.epochs = 10000;
net = train(net, ins', outs', 'useParallel', 'yes', 'useGPU', 'yes');

roiLin = reshape(allBandsImg(roi(1):roi(2), roi(3):roi(4), 1:16), (roi(2) - roi(1) + 1) * (roi(4) - roi(3) + 1), 16);
out = net(roiLin');

preview = reshape(out', roi(2) - roi(1) + 1, roi(4) - roi(3) + 1, bands - 16); 

filename = ['leonardoPreview-', num2str(trainingSetSize), '-', num2str(layers(1)), 'x', num2str(layers(2)), '.png'];

imwrite(preview(:,:,6), filename);

filename = ['leonardoDiff-', num2str(trainingSetSize), '-', num2str(layers(1)), 'x', num2str(layers(2)), '.png'];

imwrite(allBandsImg(roi(2)-roi(1), roi(4)-roi(3),22)-preview(:,:,6),filename);

end
