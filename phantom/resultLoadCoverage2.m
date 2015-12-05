function [errorClean, errorPent] = resultLoadCoverage2(path)
% [errorClean, errorPent] = resultLoadCoverage2(path) - if path is
% not specified default is taken is taken.
%
% Function loads whole directory with computed ANN. Expected filename of
% each file is in format 'coverage-C' + cov + '-l' + l + '-c' +c + '.mat'
% - cov describes coverage in percents
% - l defines ANN width (ANN has two layers of size 50*l and 15*l)
% - c distinguish between many traning cycles (same scenario)
%
% Missing files are reported as warning message.

if nargin < 1
    path = '/Volumes/home/pgs/matlab/difference_measure/coverage2/';
end

% due to the error between 10 and 20 even numbers were used instead of odd
COV = [1,3,5,7,9,10,12,14,16,18,20,21,23,25,27,29,31,33,35,37,39];
% total number of layers
L = 10;
% total number of cycles
C = 20;
% sample position in phantom (there was used phantom without noise, all
% rows per one color have same results
samples = 10:40:480;

% output fields
errorClean = zeros(size(COV,2), L, C, size(samples,2), 16);
errorPent = zeros(size(COV,2), L, C, size(samples,2), 16);

i = 1;
for cov=COV
    for l=1:L
        for c=1:C
            filename = [path, 'coverage-C', num2str(cov), '-l', num2str(l), '-c', num2str(c), '.mat'];
            if ~exist(filename, 'file')
                warning(['File does not exist: ', filename]);
                continue
            end
            load(filename, 'err');
            errorClean(i, l, c, :, :) = reshape(err.oneLayer(samples,:),1,1,1,size(samples,2),16);
            errorPent(i, l, c, :, :) = reshape(err.twoLayers(samples,:),1,1,1,size(samples,2),16);
        end
    end
    i = i + 1;
end

% graph drawing with descirption
[X, Y] = meshgrid(COV,(1:10)*65);
% as a result we use best trained ANN and its mean error per pixel 
% (material) and spectral band
mesh(X',Y',min(mean(mean(errorClean, 5),4),[],3));
hold on;
% there we draw also error in pixels with underdrawing - this should be
% maximized
mesh(X',Y',min(mean(mean(errorPent, 5),4),[],3));
set(gca,'ZScale', 'log');

title('Coverage effect on extrapolation error');
xlabel('pentimenti coverage in %');
ylabel('ANN size in numbers of neurons');
zlabel('Mean error per pixel without pentimenti');

end