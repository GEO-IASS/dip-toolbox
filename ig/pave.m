function pavedImg = pave(cube, width, height, borders)
% Function takes image cube and creates 2D representation (e.g. for
% printing). Width says how many columns will be used, height number of
% rows. Finally if borders are set to true 1px space will be put between
% images.
% Expected are doubles in range [0,1].

if (width * height < size(cube,3))
    error('Number of tiles must be greater than number of dimensions');
end

if nargin == 4
    if strcmp(borders, 'black')
        pavedImg = zeros(size(cube,1) * height + height - 1, size(cube,2) * width + width - 1);
    else % white borders
        pavedImg = ones(size(cube,1) * height + height - 1, size(cube,2) * width + width - 1);
    end
   
    for z=1:size(cube,3)
        row = fix((z-1)/width);
        column = mod(int16(z-1), int16(width));        
        pavedImg(row * (size(cube,1) + 1) + 1 : (row + 1) * (size(cube,1) + 1) - 1, ...
            column * (size(cube,2) + 1) + 1: (column + 1) * (size(cube,2) + 1) - 1) = cube(:,:,z);
    end
    
else
    pavedImg = zeros(size(cube,1) * height, size(cube,2) * width);
    for z=1:size(cube,3)
        row = fix((z-1)/width);
        column = mod(int16(z-1), int16(width));        
        pavedImg(row * size(cube,1) + 1 : (row + 1) * size(cube,1), ...
            column * size(cube,2) + 1: (column + 1) * size(cube,2)) = cube(:,:,z);
    end    
end



end