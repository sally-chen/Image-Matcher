function [templates, dimensions] = readInTemplates

inputFolderRoot = './DIGITS_CROP';
idx = 1 ;
for s = 1 : 3 
    inputFolder = fullfile( inputFolderRoot , ['Scale_', num2str(s)]) ;
    
    for i = 0 : 9 
        templateFile = [ num2str(i), '.png'];
        
        templates{idx} = imread( fullfile( inputFolder , templateFile ) ) ;
        dimensions(idx).height = size( templates{idx},1) ;
        dimensions(idx).width  = size( templates{idx},2) ;
        
        idx = idx + 1 ;
    end
end