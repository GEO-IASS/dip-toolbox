function diff = getDiff( target, extrapolation, dimension )
%GETDIFF Function computes difference between target and extrapolation and
%scale this value without shifting in [0,1]
%   dimension define which dimension will be stored into output

    rawDiff = target(:,:,dimension)-extrapolation(:,:,dimension);
    
    rawDiff(rawDiff < 0) = rawDiff(rawDiff < 0)/-min(min(rawDiff));
    rawDiff(rawDiff > 0) = rawDiff(rawDiff > 0)/max(max(rawDiff));

    diff = rawDiff;

end

