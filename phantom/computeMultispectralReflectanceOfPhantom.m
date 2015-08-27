function imageCollection = computeMultispectralReflectanceOfPhantom( phantom, materials, wavelengths )
% A mighty function for image collection creation from phantom parameters.
% There is expected input. Phantom is 3D matrix where dimensions are
% (width, height, layers) - there is defined for each pixel its layers
% (materials). Materials are then described in materials structure. This
% structure has fields: r (reflectance) and t (transmittance). In this
% fields spectral values are stored (for each nanometer a value).
% Function computes image collection for specified wavelengths.

width = size(phantom, 1);
height = size(phantom, 2);

imageCollection = zeros(width, height, size(wavelengths, 1));

for w=1:width
    for h=1:height
        for lambda=1:size(wavelengths)
            imageCollection(w, h, lambda) = r(0) + (1 - r(0)) * thruAndBack();
        end
    end
end

end

% reflection of first layer
I * r(1) 
% reflection from second layer
I * (1-r(1))^2 * t(1)^2 * r(2) r(1) * t(1)^2 * r(2)

function b = back(I, r)
    b = I * r;
end

function tab = thruAndBack(I, layerID, r, t)
    thru = I * t(layerID) ^ 2 * (1 - r(layerID)) + ;
    % reflection
    direct = thru * r(2) + thruAndBack();
    % double reflection
    % TODO
    tab = direct * trans;
end