function annDepthMaterials()
    
    rng('shuffle');

    for materials=10:10:120
        for layers=1:9
            for fileId=1:20
                filename = ['materials-rnd-M', num2str(materials), '-layers', num2str(layers), '-c', num2str(fileId), '.mat']
                if (exist(filename,'file') == 2)
                    display('File already exist, skipping: ', filename);
                else
                    computeANN5(materials, layers, fileId);
                end
            end
        end
    end

end