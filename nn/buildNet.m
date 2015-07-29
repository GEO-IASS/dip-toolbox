function net = buildNet(W, layers, in, out)

w1len = (layers(1) + 1) * layers(2);
net{1} = reshape(W(1:w1len), layers(1) + 1, layers(2));
w2len = (layers(2) + 1) * layers(3);
net{2} = reshape(W(w1len + 1 : w1len + w2len), layers(2) + 1, layers(3));
w3len = (layers(3) * layers(4));
net{3} = reshape(W(w1len + w2len + 1 : w1len + w2len + w3len), layers(3), layers(4));

end