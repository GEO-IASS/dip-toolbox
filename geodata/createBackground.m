function bckg = createBackground( intensityImage, dim )
%CREATEBACKGROUND Summary of this function goes here
%   Detailed explanation goes here

    if nargin<2
        if size(intensityImage,3) == 6
            dim = 5;
        else
            dim = 1;
        end
    end

    bckg = (intensityImage(:,:,dim) + ones(size(intensityImage(:,:,dim))))/2;
    
end

