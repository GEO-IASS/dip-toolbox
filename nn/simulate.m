function out = simulate(net, in)

X1 = horzcat(in, ones(size(in,1), 1));
X2 = horzcat(s(X1 * net{1}), ones(size(in,1), 1));
X3 = s(X2 * net{2});

out = X3 * net{3};

end

function sigmoid = s(x, lambda)
% computation of sigmoid function
if (nargin < 2)
    % when gradient of sigmoid is not defined one is taken
    lambda = 1;
end

% matrix computation of sigmoid (for each value)
sigmoid = ones(size(x))./(ones(size(x)) + ones(size(x)).*exp(-x * lambda));

end