function [pentimenti, clean] = extractMaterial(mraw, id, mask)

    pentimenti = mraw{id}(mask == 0,:);
    clean = mraw{id}(mask == 0.5,:);

    if size(pentimenti, 1) < 50
        warning(['Invisible pentimenti for sample: ', num2str(id), ' -> ', num2str(size(pentimenti,1))], ' pixels');
        subset = int16(rand(100, 1) * (size(mraw(id),1) - 1) + 1);
        pentimenti = mraw{id}(subset,:);
    end
end