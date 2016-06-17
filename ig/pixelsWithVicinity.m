function pixelArray = pixelsWithVicinity(image, areaWidth)

dim = size(image,3);
pixels = areaWidth ^ 2;

% in the array goes all neighboring pixels
pixelArray = zeros(size(image,1), size(image,2), dim * pixels + 2);

for x=1:size(image,1) - areaWidth + 1
    for y=1:size(image,2) - areaWidth + 1
        pixelArray(x,y,dim*pixels + 1) = double(y)/size(image,2);
        pixelArray(x,y,dim*pixels + 2) = double(x)/size(image,1);
        pixelArray(x,y,1:dim*pixels) = reshape(image(x:x+areaWidth - 1,y:y + areaWidth - 1,:), 1, 1, dim * pixels);
    end
end

end