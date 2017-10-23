clc;
clear all;

[templates, dimensions] = readInTemplates; %3b

% 3c
input_img_int = rgb2gray(imread( fullfile( './' , 'thermometer.png' )));
input_img = double(input_img_int);
M = size(input_img,1);
N = size(input_img,2);
corrArray = zeros(M,N,30);

for i = 1:30
    tH = dimensions(i).height;
    tW = dimensions(i).width;
    offSetX = round(tW/2);
    offSetY = round(tH/2);
    
    no_offset = normxcorr2(double(rgb2gray(templates{i})),input_img);
    corrArray(:,:,i)=no_offset(offSetY : offSetY + M - 1, offSetX : offSetX +N-1);
    
    % 3d
    [maxCorr, maxIdx] = max(corrArray,[],3);
end

% 3e
T=0.74;
id_threshholded_px = 1;
thisCorr = zeros(size(corrArray,1),size(corrArray,2));

for i = 1: size(maxCorr,1)
    for j = 1 : size(maxCorr,2)
        if (maxCorr(i,j)>T)
            
            % 3f
            candY(id_threshholded_px) = i;
            candX(id_threshholded_px) = j;
            id_threshholded_px = id_threshholded_px + 1;
            templateIndex(id_threshholded_px) = maxIdx(i, j); 
            thisCorr(i,j) = corrArray(i,j,maxIdx(i, j));
        end
            
    end
end

imshow(input_img_int)

box_counter=0;
for i = 1:length(candY)
    if (isLocalMaximum(candX(i), candY(i), thisCorr)==1)
        drawAndLabelBox(candX(i),candY(i),templateIndex(i),dimensions );
        drawnow
        box_counter=box_counter+1;
    end
end

disp(box_counter);



