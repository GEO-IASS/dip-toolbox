function [preview, p] = trainNetGrowRoi(allBandsImg, roi, trainArea, trainingSetSize, layers);
% cilem funkce je zjistit velikost obrazku, pro ktery se NN dokaze
% adaptovat - postupne se zvetsuje obrazek, provadi se stejny training.

% argumenty: linearizovany obrazek, vystupni obrazek, velikost trenovaci
% mnoziny a velikost site

addpath('..');

trainImg = allBandsImg(trainArea(1):trainArea(2), trainArea(3):trainArea(4), :);
trainLin = reshape(trainImg, size(trainImg, 1) * size(trainImg, 2), size(trainImg,3));

imgSize = size(trainLin, 1);
bands = size(trainLin, 2);

subset = int32(rand(trainingSetSize,1) * (imgSize - 1) + 1);
ins = trainLin(subset, 1:16);
outs = trainLin(subset, 17:bands);

net = feedforwardnet(layers, 'trainscg');
net = configure(net, 'inputs', ins');
net = configure(net, 'outputs', outs');
net.trainParam.epochs = 10000;
net = train(net, ins', outs', 'useParallel', 'yes');

roiImg = allBandsImg(roi(1):roi(2), roi(3):roi(4), :);
roiLin = reshape(roiImg, size(roiImg,1) * size(roiImg,2), size(roiImg,3));

[out] = net(roiLin(:,1:16)');

preview = reshape(out', size(roiImg,1), size(roiImg,2), bands - 16); 

filename = ['leonardoPreview-', num2str(trainingSetSize), '-', num2str(layers(1)), 'x', num2str(layers(2)), '-', num2str(imgSize), '.png'];
imwrite(preview(:,:,6), filename);

filename = ['leonardoDiff-', num2str(trainingSetSize), '-', num2str(layers(1)), 'x', num2str(layers(2)), '-', num2str(imgSize), '.png'];
diff = roiImg(:,:,22) - preview(:,:,6);
%imwrite(rescaleRange(diff,0.02),filename);

p = sum(sum(diff.^2));

end
