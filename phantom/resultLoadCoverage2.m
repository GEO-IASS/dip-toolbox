function [errorClean, errorPent] = resultLoadCoverage2(path)
% [errorClean, errorPent] = resultLoadErrorPhantomSize(path) - if path is
% not specified '/Volumes/G2/data/matlab-datasets/phantomSizeVersusNNSize/'
% is taken.
% Function loads whole directory with computed ANN. Expected filename of
% each file is in format output-P${PHANTOM_ID}-M12-L${LAYERS_ID}-c${CYCLE}.mat
% Loaded variable is only error matrix for one layer -> errorClean and for
% twoLayers -> errorPent
% Missing files are reported as warning message.

    if nargin < 1
        path = '/Volumes/G2/data/matlab-datasets/coverage2/';
    end

    COV = [1,3,5,7,9,10,12,14,16,18,20,21,23,25,27,29,31,33,35,37,39];
    L = 10;
    C = 20;
    
    samples = 10:40:480;
    
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
    
    [X, Y] = meshgrid(COV,(1:10)*65);
    mesh(X',Y',min(mean(mean(errorClean, 5),4),[],3));
    hold on;
    mesh(X',Y',min(mean(mean(errorPent, 5),4),[],3));
    set(gca,'ZScale', 'log');
    
    title('Coverage effect on extrapolation error');
    xlabel('pentimenti coverage in %');
    ylabel('pentimenti coverage in %');
    ylabel('ANN size in numbers of neurons');
    zlabel('Mean error per pixel without pentimenti');
    
end