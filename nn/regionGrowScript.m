p = zeros(steps,1);
for i=0:steps-1
	['step: ', num2str(i+1)]
	targetRoi = int16([roi(1)-i*roi(1)/steps, roi(2) + i*(395-roi(2))/steps, roi(3)-i*roi(3)/steps, roi(4) + i*(294-roi(4))/steps])+1;
	for k=1:10
		[~,perf] = trainNetGrowRoi(lSmall, roi, targetRoi, trainSetSize, layers);
		p(i+1) = p(i+1) + perf;
	end
end
