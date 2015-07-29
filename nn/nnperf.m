function [performance, X3, X4] = nnperf(W, layers, inputs, targets, v0, v1, v2)

w1len = (size(inputs, 2) + 1) * layers(1);
w1 = reshape(W(1:w1len), size(inputs, 2) + 1, layers(1));
w2len = (layers(1) + 1) * layers(2);
w2 = reshape(W(w1len + 1 : w1len + w2len), layers(1) + 1, layers(2));
w3len = (layers(2) * size(targets, 2));
w3 = reshape(W(w1len + w2len + 1 : w1len + w2len + w3len), layers(2), size(targets, 2));

X1 = horzcat(inputs, ones(size(inputs,1), 1));
X2 = horzcat(s(X1 * w1), ones(size(inputs, 1), 1));
X3 = s(X2 * w2);
X4 = X3 * w3;

% target reaching error
E0 = 1/2 * (X4 - targets).^2;
% only {0,1} values in pigment layer
E1 = X3 .* (ones(size(X3)) - X3);
% only one {1} output value in pigment layer
E2 = abs(1/2*(sum(X3.^2, 2) - 1));

performance = v0 * sum(sum(E0)) + v1 * sum(sum(E1)) + v2 * sum(E2);

end
