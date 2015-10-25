function [errorClean, errorPent, snr] = resultLoadErrorMaterialsCount(path)
% [errorClean, errorPent] = resultLoadErrorPhantomSize(path) - if path is
% not specified '/Volumes/G2/data/matlab-datasets/phantomSizeVersusNNSize/'
% is taken.
% Function loads whole directory with computed ANN. Expected filename of
% each file is in format output-P${PHANTOM_ID}-M12-L${LAYERS_ID}-c${CYCLE}.mat
% Loaded variable is only error matrix for one layer -> errorClean and for
% twoLayers -> errorPent
% Missing files are reported as warning message.

    if nargin < 1
        path = '/home/gimli/tmp/materialsVsLayers/';
    end

    errorClean = zeros(11,10,20,16);
    errorPent = zeros(11,10,20,16);
    snr = zeros(11,10,20,16);
    
    for m=10:10:110
        for l=1:10
            for c=1:20
                filename = [path, 'materials-rnd-M', num2str(m), '-L', num2str(l), '-c', num2str(c), '.mat'];
                if ~exist(filename, 'file')
                    warning(['File does not exist: ', filename]);                    
                    continue
                end
                load(filename, 'err');
                
                errorClean(m/10, l, c, :) = reshape(max(err.oneLayer)-min(err.oneLayer), 1,1,1,16);
                errorPent(m/10, l, c, :) = reshape(max(err.twoLayers)-min(err.twoLayers),1,1,1,16);   
                snr(m/10, l, c, :) = reshape(min(err.twoLayers ./ err.oneLayer), 1,1,1,16);
            end
        end
    end
end