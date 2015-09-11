function computeANN( phantomID, M, layersID, fileID)
% computeANN(phantomID, M, layersID) - function for cesnet computing. 
% Function takes one phantom from directory and train one FF-ANN. Results 
% (error vectors and network itself) stores into ouput file.

cd '/storage/ostrava1/home/gimli/dip-toolbox/phantom';

phantomName = ['phantom-m', num2str(M), '-', num2str(phantomID)];
data = load(phantomName);
load('layersStore');

[err, net, perf] = estimateNirBands(data.phantom, layers{layersID}); 

filename = ['output-P', num2str(phantomID), '-M', num2str(M), '-L', num2str(layersID), '-c', num2str(fileID)];

save(filename, 'err', 'net', 'perf');

end

