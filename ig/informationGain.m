function [igScaled, extrapolation, net] = informationGain(visible, target, varargin)
% [igScaled, extrapolation] = informationGain(visible, target). Neural
% network for approximation of visible to target will be trained. By this
% neural network extrapolation is computed. Finally, information gain is
% computed as difference between target and extrapolation and scaled for
% visualization.

% Possible parameters are:
% annCount = int16 of neural networks trained (best is used for output).
% (default is 1)
% layers = array of layers width. (default [25,25])
% subregion = [x, y, width, heght] - only subregion will be processed.
% (default [0, 0, size(visible,2), size(visible,1)]).
% trainingSetSize = int32 - only number of samples is used for training.
% (default 25k)
% trainingSetSrc - matrix of source values for training (one column
% correspond with one sample). Dimension must match with size(visible,3).
% If not specified training set is selected from visible/target variables.
% trainingSetTargets - target values for training (one column correspond
% with one sample). Dimension must match with size(target,3). If not 
% specified training set is selected from visible/target variables.
% useGPU = {'yes'|'no'} Define if GPU will be used for training (default
% 'no').

width = size(visible, 2);
height = size(visible, 1);

% default settings
annCount = 1;
subregion = [0,0,width,height];
trainingSetSize = 25000;
layers = [25, 25];
useGPU = 'no';

for i = 1 : 2 : length(varargin)
    name = varargin{i};
    value = varargin{i+1};
    switch name
        case 'annCount'
            annCount = value;
        case 'subregion'
            display('Using subregion for training.');
            subregion = value;
            imshow(rescaleRange(visible(subregion(2):subregion(2)+subregion(4)-1, subregion(1):subregion(1)+subregion(3)-1, 7)));
            inputs = reshape(visible(subregion(2):subregion(2)+subregion(4)-1, subregion(1):subregion(1)+subregion(3)-1, :), subregion(4) * subregion(3), size(visible,3));
            outputs = reshape(target(subregion(2):subregion(2)+subregion(4)-1, subregion(1):subregion(1)+subregion(3)-1, :), subregion(4) * subregion(3), size(target,3));
        case 'trainingSetSize'
            trainingSetSize = value;
        case 'trainingSetSrc'
            display('Using specified input set.');
            inputs = value;
        case 'trainingSetTarget'
            display('Using specified output set.');
            outputs = value;
        case 'useGPU'
            useGPU = value;
        case 'layers'
            layers = value;
        otherwise
    end
end

%training set preparation
if (exist('inputs','var') == 0 || exist('outputs','var') == 0 ...
        || (size(inputs, 1) ~= size(outputs, 1)))
    
    if (exist('inputs','var') ~= 0 && exist('outputs','var') ~= 0 ...
        && size(inputs, 1) ~= size(outputs, 1)) % inserted parameters does not match
       error(['Using whole images for training. Training set specified dimen', ...
           'sions not match. Visible: ', size(inputs, 1), ' Targets: ' ...
           size(outputs, 1)]); 
    end    
    
    % convert input images into pixel vector useful for training
    inputs = reshape(double(visible), size(visible,1) * size(visible, 2), size(visible,3));
    outputs = reshape(double(target), size(target, 1) * size(target, 2), size(target,3));
            
end


% network preparation
net = trainNetworks(inputs, outputs, annCount, layers, trainingSetSize, useGPU);

% formating of input pixel values for ANN
toProcess = reshape(double(visible), width * height, size(visible,3))';

display('Computing approximation of target');

% processing of pixels - computation of approximation
extrapolation = reshape(net(toProcess, 'useGPU', useGPU)', size(target,1), size(target,2), size(target,3));    
igScaled = rescaleRange(target - extrapolation);

end
