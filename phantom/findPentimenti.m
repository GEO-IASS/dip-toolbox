function v = findPentimenti(m, mraw, materials, id, mul, dim)
    if (nargin < 6)
        [~, dim] = max(max(mraw{id}(:,17:30),[],1)-min(mraw{id}(:,17:30),[],1));
        dim = dim + 16;
    end
    v = zeros(size(m{id},1),1) + 0.5;
    threshold = max(0.02, mul * std(m{id}(:,dim)));
    v(mean(m{id}(:,dim)) - m{id}(:,dim) > threshold) = 0;
    v(m{id}(:,dim) - mean(m{id}(:,dim)) > threshold) = 1;
    img = zeros(size(materials{id},1), size(materials{id},2)*2);
    img(:, 1:size(materials{id},2)) = medfilt2(materials{id}(:,:,dim));
    img(:, size(materials{id},2)+1:size(materials{id},2)*2) = reshape(v, size(materials{id},1), size(materials{id},2));
    imshow(img);
end