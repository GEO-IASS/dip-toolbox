function [errorClean, errorPent] = resultLoadDepth(path)
% [errorClean, errorPent] = resultLoadDepth(path) - if path is
% not specified '/Volumes/home/pgs/matlab/difference_measure/depth/'
% is taken.
% Function loads whole directory with computed ANN. Expected filename of
% each file is in format 'materials-rnd-M', num2str(m), '-layers', num2str(l), '-c', num2str(c), '.mat'
% Missing files are reported as warning message.

% resolve path to matlab files
if nargin < 1
    path = '/Volumes/home/pgs/matlab/difference_measure/depth/';
end

% prepare output matrix
errorClean = zeros(12,10,20,16);
errorPent = zeros(12,10,20,16);

for m=10:10:120
    for l=1:10
        for c=1:20
            % go through files and load
            filename = [path, 'materials-rnd-M', num2str(m), '-layers', num2str(l), '-c', num2str(c), '.mat'];
            if ~exist(filename, 'file')
                warning(['File does not exist: ', filename]);
                continue
            end
            load(filename, 'err');
            
            % store error measures in output matrices
            errorClean(m/10, l, c, :) = reshape(mean(err.oneLayer,1) / 20, 1,1,1,16);
            errorPent(m/10, l, c, :) = reshape(mean(err.twoLayers) / 20,1,1,1,16);
        end
    end
end
end