function ind = net2ind(net)

s(1) = size(net{1}, 1) * size(net{1}, 2);
s(2) = size(net{2}, 1) * size(net{2}, 2);
s(3) = size(net{3}, 1) * size(net{3}, 2);

ind = zeros(1,sum(s));
ind(1 : s(1)) = reshape(net{1}, 1, s(1));
ind(1 + s(1) : s(1) + s(2)) = reshape(net{2}, 1, s(2));
ind(1 + s(1) + s(2) : s(1) + s(2) + s(3)) = reshape(net{3}, 1, s(3));

end
