function [net, bX3, performance] = nnaprox(inputs, innerLayerSize, targets)

alpha = 0.0005;
beta = 0.2;
gamma = 0.05;

% inputs have size n x input dimensionality
% targets have size n x output dimensionality
% inner layer is array of two numbers, first layer computes features,
% second layer computes classes

% rename incoming parameters
X1 = horzcat(inputs, ones(size(inputs,1), 1));
T = targets;
% random seed of the network
w1 = rand(size(inputs,2) + 1, innerLayerSize(1)) - 0.5;
w2 = rand(innerLayerSize(1) + 1, innerLayerSize(2)) - 0.5;
w3 = rand(innerLayerSize(2), size(targets, 2)) - 0.5;

% moment for faster adaptation
m1 = zeros(size(w1));
m2 = zeros(size(w2));
m3 = zeros(size(w3));

best = Inf;
counter = 0;
i=0;
while(true)
    i = i+1;    
    gamma = 0.01 + 0.02 * i^(1/4);
    delta = 0.01 + 0.02 * i^(1/4);

    % computation of performance
    X2 = horzcat(s(X1 * w1), ones(size(inputs, 1), 1));
    X3 = s(X2 * w2);
    X4 = X3 * w3;
    
    % target reaching error
    E0 = 1/2 * (X4 - T).^2;
    % only {0,1} values in pigment layer
    E1 = X3 .* (ones(size(X3)) - X3);
    % only one {1} output value in pigment layer
    E2 = 1/2*(sum(X3, 2) - 1).^2;
    
    % composition of performance
    performance = sum(sum(E0, 2) + gamma * sum(E1, 2) + delta * E2);
    if (performance < best)
        if (best - performance < best/100000)
            counter = counter + 1;
        else
            counter = 0;
        end
        if counter > 100
            warning('step too small');
            break;
        end
        best = performance
        bw1 = w1;
        bw2 = w2;
        bw3 = w3;
        bX3 = X3;
        grows = 0;
    else
        grows = grows + 1;
        if grows > 12
            break;
        end
        if grows >= 6
            alpha = alpha/10;
            m1 = zeros(size(w1));
            m2 = zeros(size(w2));
            m3 = zeros(size(w3));
            warning(['grows: ' int2str(grows)]);
        end
    end
    
    % adaptation step
    d3 = (X4 - T);
    dw3 = (d3' * X3)';
    % classificator layer
    E0d2 = d3 * w3';
    E1d2 = (ones(size(X3)) - 2 * X3);
    E2d2 = sum(X3,2) * ones(1,innerLayerSize(2)) - 1;
    d2 = (E0d2 + gamma * E1d2 + delta * E2d2) .* X3 .* (ones(size(X3)) - X3);
    dw2 = (d2' * X2)';
    % feature set
    d1 = (d2 * w2') .* X2 .* (ones(size(X2)) - X2);
    d1 = d1(:, 1:innerLayerSize(1));
    dw1 = (d1' * X1)';
    
    w1 = w1 - dw1 * alpha + m1 * beta;
    w2 = w2 - dw2 * alpha + m2 * beta;
    w3 = w3 - dw3 * alpha + m3 * beta;
    
    m1 = - dw1 * alpha + m1 * beta;
    m2 = - dw2 * alpha + m2 * beta;
    m3 = - dw3 * alpha + m3 * beta;

end

net = {bw1, bw2, bw3};

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