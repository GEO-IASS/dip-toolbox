function sigmoid = s(x, lambda)
% computation of sigmoid function
if (nargin < 2)
    % when gradient of sigmoid is not defined one is taken
    lambda = 1;
end

% matrix computation of sigmoid (for each value)
sigmoid = ones(size(x))./(ones(size(x)) + ones(size(x)).*exp(-x * lambda));

end