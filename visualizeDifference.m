function image = visualizeDifference(intensityImage, diff, hueA, hueB)
% Algorithm published in Digital Heritage 2013 "Image Fusion for Difference
% Visualization in Art Analysis". Algorithm makes visualization of diff on
% intensity image. Difference is mapped to colour. Expected values of
% difference are [-1, 1] (but if not normalization is applied).
% 
% USAGE:
% image = visualizeDifference(intensityImage, differenceValues) takes two
% input parameters. The first parameter is grayscale image (values in range
% [0,1]). The second parameter differenceValues contains matrix (the same
% size as intensityImage), where for each pixel is value of its
% "difference". For negative values is used yellow color and for positive
% values is used red color. Absolute value of the difference determine
% saturation of pixel on resulting image.
%
% image = visualizeDifference(intensityImage, differenceValues,
% negativeHue, positiveHue) allow to define used hue for positive and
% negative difference values. Hue is moduled by 2?.

numOfPixels = size(intensityImage,1)*size(intensityImage,2);

% if not yet converted, make doubles.
intensityImage = double(intensityImage);

% if no output color is defined, use default
if (nargin < 4)
    hueA = pi/3;
    hueB = 4*pi/3;
end

% if difference is not in double values - convert it also
diff = double(diff);
% normalize values of difference into range [-pi/4, pi/4]
diff = diff/max(max(abs(diff)))*pi/4;

% here magic begins
%  - Lsh (lightness, saturation, hue) conversion
%  - M represents length of color vector
M = double(reshape(intensityImage,numOfPixels,1))*100;
hue = reshape(diff > 0, numOfPixels, 1);
hue = (hue * hueA) - ((hue - 1) * hueB);
saturation = reshape(diff, numOfPixels, 1);

% from hue and saturation extract standard values of Lab color space
L = M .* cos(saturation);
a = M .* abs(sin(saturation)) .* cos(hue);
b = M .* abs(sin(saturation)) .* sin(hue);

% create output image in Lab color format
output(:,:,1) = reshape(L, size(intensityImage,1), size(intensityImage,2), 1);
output(:,:,2) = reshape(a, size(intensityImage,1), size(intensityImage,2), 1);
output(:,:,3) = reshape(b, size(intensityImage,1), size(intensityImage,2), 1);

% convert image into RGB
image = Lab2RGB(output);

% image preview
imshow(image);

end