function out = rescaleRange(values, mn, mx)
% A data normalization function.
%
% out = rescaleRange(values) shifts values in range [0,1] linearily.
%
% out = rescaleRange(values, fraction) takes values in range 
% [quantile(fraction/2), quantile(1-faction/2)] and shifts them into [0,1]
% values out of this range are set to 0 or 1 respectively. Fraction is a
% double in range [0,1].
%
% out = rescaleRange(values, min, max) shifts values in range 
% [0,1]. Values >= max are transformed to 1 and values <= min are  
% transformed to 0. Values between min and max are transformed
% linearily.
%
% Output values are in range [0,1].
%
% max and min cannot be the same number (otherwise NaN is in the
% output).

    if (nargin < 3) 
        len = numel(values);
        a = reshape(values, len, 1);
        if (nargin == 1)
            mn = min(a);
            mx = max(a);
        elseif (nargin == 2)
            perc = mn;
            mn = quantile(a, perc/2);
            mx = quantile(a, 1-perc/2);
        end
    end

    out = values;
    out(out < mn) = mn;
    out(out > mx) = mx;
    out = (out - mn)/(mx-mn);

end