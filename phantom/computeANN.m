function computeANN( phantomID, M, layersID)
% computeANN(phantomID, M, layersID) - function for cesnet computing. 
% Function takes one phantom from directory and train one FF-ANN. Results 
% (error vectors and network itself) stores into ouput file.

cd '/storage/ostrava1/home/gimli/dip-toolbox/phantom';

phantomName = ['phantom-m', num2str(M), '-', num2str(phantomID)];
load(phantomName);
load('layersStore');

[err, net] = estimateNirBands(phantom, layers{layersID}); 

filename = ['output-P', num2str(phantomID), '-M', num2str(M), '-L', num2str(layersID)];

save(filename, 'err', 'net');

end

