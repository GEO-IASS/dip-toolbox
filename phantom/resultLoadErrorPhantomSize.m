function [errorClean, errorPent] = resultLoadErrorPhantomSize(path)
% [errorClean, errorPent] = resultLoadErrorPhantomSize(path) - if path is
% not specified '/Volumes/G2/data/matlab-datasets/phantomSizeVersusNNSize/'
% is taken.
% Function loads whole directory with computed ANN. Expected filename of
% each file is in format output-P${PHANTOM_ID}-M12-L${LAYERS_ID}-c${CYCLE}.mat
% Loaded variable is only error matrix for one layer -> errorClean and for
% twoLayers -> errorPent
% Missing files are reported as warning message.

    if nargin < 1
        path = '/Volumes/G2/data/matlab-datasets/phantomSizeVersusNNSize/';
    end

    errorClean = zeros(10, 10, 10, 12, 16);
    errorPent = zeros(10, 10, 10, 12, 16);
    
    for p=1:10
        for l=1:10
            for c=1:10
                filename = [path, 'output-P', num2str(p), '-M12-L', num2str(l), '-c', num2str(c), '.mat'];
                if ~exist(filename, 'file')
                    warning(['File does not exist: ', filename]);
                    continue
                end
                load(filename, 'err');
                errorClean(p, l, c, :, :) = reshape(err.oneLayer,1,1,1,12,16);
                errorPent(p, l, c, :, :) = reshape(err.twoLayers,1,1,1,12,16);
            end
        end
    end
end